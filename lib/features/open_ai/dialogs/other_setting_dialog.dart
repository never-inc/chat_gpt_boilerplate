import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/extensions/context_extension.dart';
import '../../../core/res/text_styles.dart';
import '../providers/cache/cache_messages.dart';

class OtherSettingDialog extends ConsumerStatefulWidget {
  const OtherSettingDialog({super.key});

  static Future<void> show(BuildContext context) => showDialog<void>(
        context: context,
        routeSettings: const RouteSettings(
          name: 'other_setting_dialog',
        ),
        builder: (BuildContext context) {
          return const OtherSettingDialog();
        },
      );

  @override
  ConsumerState<OtherSettingDialog> createState() => _State();
}

class _State extends ConsumerState<OtherSettingDialog> {
  @override
  Widget build(BuildContext context) {
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
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Card(
                    elevation: 0,
                    color: context.backgroundColor,
                    margin: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(width: 0.5, color: Colors.grey),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12).copyWith(
                              topLeft: Radius.zero,
                              topRight: Radius.zero,
                            ),
                          ),
                          title: Text(
                            context.l10n.deleteMessages,
                            style: context.mediumStyle,
                          ),
                          trailing: const Icon(Icons.delete, size: 16),
                          onTap: () async {
                            final okDialog = await showOkCancelAlertDialog(
                              context: context,
                              title: context.l10n.messageDeletionQuestionTitle,
                            );
                            if (okDialog != OkCancelResult.ok) {
                              return;
                            }
                            try {
                              await ref.read(cacheMessagesProvider).clear();
                              ref.invalidate(cacheMessagesProvider);
                              if (context.mounted) {
                                showOkAlertDialog(
                                  context: context,
                                  title: context.l10n.messageDeletionSucceeded,
                                ).ignore();
                              }
                            } catch (e) {
                              debugPrint(e.toString());
                              if (context.mounted) {
                                showOkAlertDialog(
                                  context: context,
                                  title: context.l10n.messageDeletionFailed,
                                ).ignore();
                              }
                            }
                          },
                        ),
                        const Divider(height: 1),
                        ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12).copyWith(
                              topLeft: Radius.zero,
                              topRight: Radius.zero,
                            ),
                          ),
                          title: Text(
                            context.l10n.deleteImageCaches,
                            style: context.mediumStyle,
                          ),
                          trailing: const Icon(Icons.delete, size: 16),
                          onTap: () async {
                            final okDialog = await showOkCancelAlertDialog(
                              context: context,
                              title:
                                  context.l10n.imageCachesDeletionQuestionTitle,
                            );
                            if (okDialog != OkCancelResult.ok) {
                              return;
                            }
                            try {
                              await DefaultCacheManager().emptyCache();
                              if (context.mounted) {
                                showOkAlertDialog(
                                  context: context,
                                  title:
                                      context.l10n.imageCachesDeletionSucceeded,
                                ).ignore();
                              }
                            } catch (e) {
                              debugPrint(e.toString());
                              if (context.mounted) {
                                showOkAlertDialog(
                                  context: context,
                                  title: context.l10n.imageCachesDeletionFailed,
                                ).ignore();
                              }
                            }
                          },
                        ),
                      ],
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
      ),
    );
  }
}
