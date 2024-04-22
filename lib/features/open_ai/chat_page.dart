import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/extensions/context_extension.dart';
import '../../core/gen/assets.gen.dart';
import '../../core/res/text_form_field_decoration.dart';
import '../../core/res/text_styles.dart';
import '../../core/widgets/locale_icon.dart';
import '../../core/widgets/theme_icon.dart';
import 'providers/message/fetch_messages.dart';
import 'providers/message/message.dart';
import 'providers/message/send_message.dart';
import 'providers/setting/open_ai_chat_mode.dart';
import 'widgets/date_tile.dart';
import 'widgets/left_loading_tile.dart';
import 'widgets/left_message_tile.dart';
import 'widgets/right_message_tile.dart';
import 'widgets/setting_drawer.dart';

class ChatPage extends ConsumerStatefulWidget {
  const ChatPage({super.key});

  @override
  ConsumerState<ChatPage> createState() => _State();
}

class _State extends ConsumerState<ChatPage> {
  final _textEditingController = TextEditingController();
  final _focusScopeNode = FocusScopeNode();
  final _scrollController = ScrollController();

  bool _resizeToAvoidBottomInset = true;
  bool _focusedFormField = false;
  bool _isKeyDownMetaLeft = false;
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    void scrollToBottom() {
      if (_scrollController.hasClients &&
          _scrollController.position.pixels > 0) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.linear,
        );
      }
    }

    void hideKeyBoard() {
      context.hideKeyboard();
      _focusScopeNode.unfocus();
    }

    Future<void> submit() async {
      final text = _textEditingController.value.text.trim();
      if (text.isEmpty) {
        return;
      }

      try {
        final result = await ref.read(sendMessageProvider.notifier)(
          text: text,
          roomId: Message.roomId,
          onCall: ({required bool isSending}) {
            if (isSending) {
              HapticFeedback.heavyImpact().ignore();
              _textEditingController.clear();
              scrollToBottom();
            }
          },
        );
        if (result) {
          Future.delayed(
            const Duration(milliseconds: 500),
            scrollToBottom,
          );
        }
      } catch (e) {
        hideKeyBoard();
        if (context.mounted) {
          showOkAlertDialog(
            context: context,
            title: e.toString(),
          ).ignore();
        }
      }
    }

    final chatMode = ref.watch(openAIChatModeProvider);
    final messagesAsyncValue = ref.watch(fetchMessagesProvider);

    return GestureDetector(
      onTap: hideKeyBoard,
      child: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: context.isDark
                ? Assets.images.darkSky.provider()
                : Assets.images.lightSky.provider(),
          ),
          color: context.scaffoldBackgroundColor,
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: _resizeToAvoidBottomInset,
          drawer: const SettingDrawer(),
          onDrawerChanged: (value) {
            setState(() {
              _resizeToAvoidBottomInset = !value;
            });
          },
          appBar: AppBar(
            backgroundColor: context.backgroundColor.withOpacity(0.2),
            automaticallyImplyLeading: false,
            leading: Builder(
              builder: (context) {
                return IconButton(
                  onPressed: () {
                    hideKeyBoard();
                    Scaffold.of(context).openDrawer();
                  },
                  icon: const Icon(Icons.settings),
                  color: Colors.white,
                );
              },
            ),
            actions: const [
              LocaleIcon(
                color: Colors.white,
              ),
              Padding(
                padding: EdgeInsets.only(right: 8),
                child: ThemeIcon(
                  color: Colors.white,
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              /// Messages
              Expanded(
                child: NotificationListener<ScrollUpdateNotification>(
                  onNotification: (notification) {
                    final items = messagesAsyncValue.asData?.value ?? [];
                    if (items.length >= Message.pageSize &&
                        notification.metrics.extentAfter == 0) {
                      Future(() async {
                        if (_isLoading) {
                          return;
                        }
                        _isLoading = true;
                        try {
                          await ref
                              .read(fetchMessagesProvider.notifier)
                              .fetchMore();
                        } on Exception catch (e) {
                          debugPrint(e.toString());
                        } finally {
                          _isLoading = false;
                        }
                      });
                    }
                    return true;
                  },
                  child: messagesAsyncValue.when(
                    error: (e, _) => Center(
                      child: Text(
                        e.toString(),
                        style: context.mediumStyle,
                      ),
                    ),
                    loading: () => const Center(
                      child: CupertinoActivityIndicator(),
                    ),
                    data: (res) {
                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 8,
                        ),
                        physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics(),
                        ),
                        reverse: true,
                        controller: _scrollController,
                        itemBuilder: (context, index) {
                          final robotName = context.l10n.robotName;
                          final robotAvatar = CircleAvatar(
                            backgroundColor: context.backgroundColor,
                            foregroundColor: context.iconColor,
                            child: const Icon(Icons.smart_toy_outlined),
                          );
                          final backgroundColor = context.backgroundColor;

                          final message = res[index];
                          final date = Message.getDateTile(
                            index,
                            res.map((e) => e.date).toList(),
                          );

                          return Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (date != null)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    child: DateTile(date: date),
                                  ),
                                switch (message) {
                                  TextMessage(
                                    :final text,
                                    :final images,
                                    :final date,
                                    :final userType
                                  ) =>
                                    switch (userType) {
                                      UserType.robot => LeftMessageTile(
                                          text: text,
                                          imageUrls: images
                                              ?.map((e) => e.url)
                                              .whereType<String>()
                                              .toList(),
                                          date: date,
                                          name: robotName,
                                          avatar: robotAvatar,
                                          backgroundColor: backgroundColor,
                                        ),
                                      UserType.you => RightMessageTile(
                                          text: text,
                                          date: date,
                                          backgroundColor: backgroundColor,
                                        ),
                                    },
                                  WelcomeMessage(:final date) =>
                                    LeftMessageTile(
                                      text: context.l10n.welcomeMessage,
                                      date: date,
                                      name: robotName,
                                      avatar: robotAvatar,
                                      backgroundColor: backgroundColor,
                                    ),
                                  Loading() => LeftLoadingTile(
                                      name: robotName,
                                      avatar: robotAvatar,
                                      backgroundColor: backgroundColor,
                                    ),
                                },
                              ],
                            ),
                          );
                        },
                        itemCount: res.length,
                      );
                    },
                  ),
                ),
              ),

              /// Input footer
              ColoredBox(
                color: context.backgroundColor,
                child: SafeArea(
                  maintainBottomViewPadding: true,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SizedBox(
                              width: 52,
                              height: 32,
                              child: GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () async {
                                  HapticFeedback.heavyImpact().ignore();
                                  final result = await showModalActionSheet<
                                      OpenAIChatModeType>(
                                    context: context,
                                    title: context.l10n.openAIChatModeTitle,
                                    actions: [
                                      SheetAction(
                                        label: OpenAIChatModeType.text.value,
                                        key: OpenAIChatModeType.text,
                                        icon: Icons.text_fields_outlined,
                                        textStyle: context.mediumStyle,
                                      ),
                                      SheetAction(
                                        label: OpenAIChatModeType.image.value,
                                        key: OpenAIChatModeType.image,
                                        icon: Icons.photo_outlined,
                                        textStyle: context.mediumStyle,
                                      ),
                                    ],
                                    cancelLabel: context.l10n.close,
                                  );
                                  if (result != null) {
                                    await ref
                                        .read(
                                          openAIChatModeProvider.notifier,
                                        )
                                        .save(result);
                                  }
                                },
                                child: Text.rich(
                                  TextSpan(
                                    children: [
                                      WidgetSpan(
                                        child: Icon(
                                          chatMode == OpenAIChatModeType.image
                                              ? Icons.photo_outlined
                                              : Icons.text_fields_outlined,
                                        ),
                                        alignment: PlaceholderAlignment.middle,
                                      ),
                                      const WidgetSpan(
                                        child: Icon(Icons.arrow_drop_down),
                                        alignment: PlaceholderAlignment.middle,
                                      ),
                                    ],
                                  ),
                                  style: context.mediumStyle.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.start,
                                  maxLines: 1,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 4),
                                child: FocusScope(
                                  node: _focusScopeNode,
                                  onFocusChange: (value) {
                                    setState(() {
                                      _focusedFormField = value;
                                    });
                                  },
                                  onKeyEvent: (node, event) {
                                    if (_isKeyDownMetaLeft &&
                                        event.logicalKey ==
                                            LogicalKeyboardKey.enter) {
                                      _isKeyDownMetaLeft = false;
                                      submit();
                                      return KeyEventResult.handled;
                                    } else {
                                      _isKeyDownMetaLeft =
                                          event is KeyDownEvent &&
                                              event.logicalKey ==
                                                  LogicalKeyboardKey.metaLeft;
                                      return KeyEventResult.ignored;
                                    }
                                  },
                                  child: TextFormField(
                                    controller: _textEditingController,
                                    style: context.mediumStyle,
                                    decoration:
                                        TextFormFieldDecoration.textMessage(
                                      context,
                                    ),
                                    minLines: 1,
                                    maxLines: 7,
                                    maxLength: 256,
                                    textInputAction: TextInputAction.newline,
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              padding: const EdgeInsets.only(top: 2),
                              onPressed: _focusedFormField ? submit : null,
                              icon: const Icon(Icons.send_rounded),
                              color: Colors.blueAccent,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
