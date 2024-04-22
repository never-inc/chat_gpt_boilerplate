import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../core/extensions/context_extension.dart';
import '../../../core/res/text_form_field_decoration.dart';
import '../../../core/res/text_styles.dart';
import '../providers/setting/chat_system_message.dart';

class ChatSystemSettingDialog extends ConsumerStatefulWidget {
  const ChatSystemSettingDialog({super.key});

  static Future<void> show(BuildContext context) => showDialog<void>(
        context: context,
        routeSettings: const RouteSettings(
          name: 'chat_system_setting_dialog',
        ),
        builder: (BuildContext context) {
          return const ChatSystemSettingDialog();
        },
      );

  @override
  ConsumerState<ChatSystemSettingDialog> createState() => _State();
}

class _State extends ConsumerState<ChatSystemSettingDialog> {
  final _textEditingController = TextEditingController();
  final _focusScopeNode = FocusScopeNode();
  bool _isKeyDownMetaLeft = false;

  @override
  void initState() {
    super.initState();
    final state = ref.read(chatSystemMessageProvider);
    _textEditingController.text = state ?? '';
  }

  @override
  Widget build(BuildContext context) {
    Future<void> submit() async {
      context.hideKeyboard();
      final value = _textEditingController.text.trim();
      await ref.read(chatSystemMessageProvider.notifier).save(value);
      if (context.mounted) {
        Navigator.of(context).pop();
      }
    }

    return GestureDetector(
      onTap: context.hideKeyboard,
      child: AlertDialog(
        content: SizedBox(
          width: 320,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: FocusScope(
                    node: _focusScopeNode,

                    /// Macで Command + Enter で送信できるように設定
                    onKeyEvent: (node, event) {
                      if (_isKeyDownMetaLeft &&
                          event.logicalKey == LogicalKeyboardKey.enter) {
                        _isKeyDownMetaLeft = false;
                        submit();
                        return KeyEventResult.handled;
                      } else {
                        _isKeyDownMetaLeft = event is KeyDownEvent &&
                            event.logicalKey == LogicalKeyboardKey.metaLeft;
                        return KeyEventResult.ignored;
                      }
                    },
                    child: TextFormField(
                      controller: _textEditingController,
                      style: context.mediumStyle,
                      decoration: TextFormFieldDecoration.input(
                        context,
                        hintText: context.l10n.chatSystemMessagePlaceholder,
                        suffixIcon: IconButton(
                          onPressed: () {
                            HapticFeedback.heavyImpact();
                            _textEditingController.clear();
                          },
                          icon: const Icon(Icons.close),
                        ),
                      ),
                      minLines: 3,
                      maxLines: 7,
                      textInputAction: TextInputAction.newline,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () async {
                        const urlString =
                            'https://platform.openai.com/docs/api-reference/chat/create';
                        final canLaunch = await canLaunchUrlString(urlString);
                        if (canLaunch) {
                          await launchUrlString(
                            urlString,
                            mode: LaunchMode.externalApplication,
                          );
                        }
                      },
                      child: Text(
                        context.l10n.aboutSystemMessage,
                        style: context.mediumStyle.copyWith(
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),
                  ),
                ),
                FilledButton(
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(160, 40),
                  ),
                  onPressed: submit,
                  child: Text(
                    context.l10n.save,
                    style: context.mediumStyle.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
