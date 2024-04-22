import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../core/extensions/context_extension.dart';
import '../../../core/res/text_form_field_decoration.dart';
import '../../../core/res/text_styles.dart';
import '../../open_ai/providers/setting/open_ai_api_key.dart';

class OpenAIAPIKeySettingDialog extends ConsumerStatefulWidget {
  const OpenAIAPIKeySettingDialog({super.key});

  static Future<void> show(BuildContext context) => showDialog<void>(
        context: context,
        routeSettings: const RouteSettings(
          name: 'open_ai_api_key_setting_dialog',
        ),
        builder: (BuildContext context) {
          return const OpenAIAPIKeySettingDialog();
        },
      );

  @override
  ConsumerState<OpenAIAPIKeySettingDialog> createState() => _State();
}

class _State extends ConsumerState<OpenAIAPIKeySettingDialog> {
  final _textEditingController = TextEditingController();

  var _isVisible = false;

  @override
  void initState() {
    super.initState();
    final state = ref.read(openAIAPIKeyProvider);
    _textEditingController.text = state ?? '';
  }

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
                  padding: const EdgeInsets.only(top: 8),
                  child: TextFormField(
                    controller: _textEditingController,
                    style: context.mediumStyle,
                    decoration: TextFormFieldDecoration.input(
                      context,
                      labelText: context.l10n.openAIAPIKey,
                      suffixIcon: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          HapticFeedback.heavyImpact();
                          setState(() {
                            _isVisible = !_isVisible;
                          });
                        },
                        child: Icon(
                          _isVisible
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                      ),
                    ),
                    minLines: 1,
                    obscureText: !_isVisible,
                    textInputAction: TextInputAction.done,
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
                            'https://platform.openai.com/account/api-keys';
                        final canLaunch = await canLaunchUrlString(urlString);
                        if (canLaunch) {
                          await launchUrlString(
                            urlString,
                            mode: LaunchMode.externalApplication,
                          );
                        }
                      },
                      child: Text(
                        context.l10n.obtainingAnAPIKey,
                        style: context.mediumStyle.copyWith(
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(160, 40),
                    ),
                    onPressed: () async {
                      context.hideKeyboard();
                      final value = _textEditingController.text.trim();
                      await ref.read(openAIAPIKeyProvider.notifier).save(value);
                      if (context.mounted) {
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text(
                      context.l10n.save,
                      style: context.mediumStyle.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    minimumSize: const Size(50, 30),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () {
                    HapticFeedback.heavyImpact();
                    _textEditingController.clear();
                  },
                  child: Text(
                    context.l10n.clear,
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
