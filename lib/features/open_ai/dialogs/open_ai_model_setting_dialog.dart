import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../core/extensions/context_extension.dart';
import '../../../core/res/text_styles.dart';
import '../providers/setting/is_enabled_past_messages.dart';
import '../providers/setting/open_ai_chat_model.dart';
import '../providers/setting/open_ai_image_model.dart';

class OpenAIModelSettingDialog extends ConsumerStatefulWidget {
  const OpenAIModelSettingDialog({super.key});

  static Future<void> show(BuildContext context) => showDialog<void>(
        context: context,
        routeSettings: const RouteSettings(
          name: 'open_ai_model_setting_dialog',
        ),
        builder: (BuildContext context) {
          return const OpenAIModelSettingDialog();
        },
      );

  @override
  ConsumerState<OpenAIModelSettingDialog> createState() => _State();
}

class _State extends ConsumerState<OpenAIModelSettingDialog> {
  @override
  Widget build(BuildContext context) {
    final chatModel = ref.watch(openAIChatModelProvider);
    final isEnabledPastMessages = ref.watch(isEnabledPastMessagesProvider);
    final imageModel = ref.watch(openAIImageModelProvider);

    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: const BorderSide(width: 0.5, color: Colors.grey),
    );
    return AlertDialog(
      content: SizedBox(
        width: 320,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 16,
                    top: 8,
                    bottom: 2,
                  ),
                  child: Text(
                    context.l10n.text,
                    style: context.mediumStyle,
                    textAlign: TextAlign.start,
                  ),
                ),
              ),
              Card(
                elevation: 0,
                color: context.backgroundColor,
                margin: EdgeInsets.zero,
                shape: shape,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 64,
                            child: Text(
                              context.l10n.model,
                              style: context.mediumStyle,
                              maxLines: 1,
                              textAlign: TextAlign.start,
                            ),
                          ),
                          Flexible(
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton2<OpenAIChatModelType>(
                                customButton: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          chatModel.value,
                                          style: context.mediumStyle.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.end,
                                        ),
                                      ),
                                      const Icon(
                                        Icons.arrow_drop_down,
                                        size: 16,
                                      ),
                                    ],
                                  ),
                                ),
                                items: OpenAIChatModelType.values
                                    .map(
                                      (item) =>
                                          DropdownMenuItem<OpenAIChatModelType>(
                                        value: item,
                                        child: Text(
                                          item.value,
                                          style: context.mediumStyle,
                                        ),
                                      ),
                                    )
                                    .toList(),
                                value: chatModel,
                                onChanged: (value) {
                                  if (value != null) {
                                    ref
                                        .read(openAIChatModelProvider.notifier)
                                        .save(value);
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              context.l10n.sendPastMessages,
                              style: context.mediumStyle,
                            ),
                          ),
                          Transform.scale(
                            scale: 0.8,
                            child: CupertinoSwitch(
                              value: isEnabledPastMessages,
                              onChanged: (value) {
                                ref
                                    .read(
                                      isEnabledPastMessagesProvider.notifier,
                                    )
                                    .save(value: value);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 16,
                    top: 12,
                    bottom: 2,
                  ),
                  child: Text(
                    context.l10n.image,
                    style: context.mediumStyle,
                    textAlign: TextAlign.start,
                  ),
                ),
              ),
              Card(
                elevation: 0,
                color: context.backgroundColor,
                margin: EdgeInsets.zero,
                shape: shape,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 64,
                            child: Text(
                              context.l10n.model,
                              style: context.mediumStyle,
                              maxLines: 1,
                              textAlign: TextAlign.start,
                            ),
                          ),
                          Flexible(
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton2<OpenAIImageModelType>(
                                customButton: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          imageModel.value,
                                          style: context.mediumStyle.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.end,
                                        ),
                                      ),
                                      const Icon(
                                        Icons.arrow_drop_down,
                                        size: 16,
                                      ),
                                    ],
                                  ),
                                ),
                                items: OpenAIImageModelType.values
                                    .map(
                                      (item) => DropdownMenuItem<
                                          OpenAIImageModelType>(
                                        value: item,
                                        child: Text(
                                          item.value,
                                          style: context.mediumStyle,
                                        ),
                                      ),
                                    )
                                    .toList(),
                                value: imageModel,
                                onChanged: (value) {
                                  if (value != null) {
                                    ref
                                        .read(
                                          openAIImageModelProvider.notifier,
                                        )
                                        .save(value);
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 16),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () async {
                      const urlString =
                          'https://platform.openai.com/docs/models';
                      final canLaunch = await canLaunchUrlString(urlString);
                      if (canLaunch) {
                        await launchUrlString(
                          urlString,
                          mode: LaunchMode.externalApplication,
                        );
                      }
                    },
                    child: Text(
                      context.l10n.aboutModels,
                      style: context.mediumStyle.copyWith(
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  minimumSize: const Size(50, 30),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: Navigator.of(context).pop,
                child: Text(
                  context.l10n.close,
                  style: context.mediumStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
