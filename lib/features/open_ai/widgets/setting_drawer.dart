import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../../core/extensions/context_extension.dart';
import '../../../core/res/text_styles.dart';
import '../dialogs/chat_system_setting_dialog.dart';
import '../dialogs/open_ai_api_key_setting_dialog.dart';
import '../dialogs/open_ai_model_setting_dialog.dart';
import '../dialogs/other_setting_dialog.dart';

class SettingDrawer extends StatelessWidget {
  const SettingDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final items = <(String, void Function(BuildContext context))>[
      (
        context.l10n.openAIAPIKey,
        OpenAIAPIKeySettingDialog.show,
      ),
      (
        context.l10n.openAISystemModel,
        OpenAIModelSettingDialog.show,
      ),
      (
        context.l10n.chatSystemMessage,
        ChatSystemSettingDialog.show,
      ),
      (
        context.l10n.other,
        OtherSettingDialog.show,
      ),
    ];

    final borderRadius = BorderRadius.circular(12);
    return Drawer(
      child: SafeArea(
        child: Scrollbar(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16, bottom: 2),
                    child: Text(
                      context.l10n.settings,
                      style: context.mediumStyle,
                    ),
                  ),
                  Card(
                    elevation: 0,
                    color: context.backgroundColor,
                    margin: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: borderRadius,
                      side: const BorderSide(width: 0.5, color: Colors.grey),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: items.mapIndexed((index, e) {
                        final isFirst = index == 0;
                        final isLast = index == items.length - 1;
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              title: Text(
                                e.$1,
                                style: context.mediumStyle,
                              ),
                              trailing: const Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: Colors.grey,
                              ),
                              shape: isFirst || isLast
                                  ? RoundedRectangleBorder(
                                      borderRadius: borderRadius.copyWith(
                                        topLeft: isLast ? Radius.zero : null,
                                        topRight: isLast ? Radius.zero : null,
                                        bottomLeft:
                                            isFirst ? Radius.zero : null,
                                        bottomRight:
                                            isFirst ? Radius.zero : null,
                                      ),
                                    )
                                  : null,
                              onTap: () {
                                e.$2(context);
                              },
                            ),
                            if (!isLast) const Divider(height: 1),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
