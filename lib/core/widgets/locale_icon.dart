import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../extensions/context_extension.dart';
import '../providers/locale_type_controller.dart';
import '../res/text_styles.dart';

class LocaleIcon extends ConsumerWidget {
  const LocaleIcon({this.color, super.key});

  final Color? color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localeType = ref.watch(localeTypeControllerProvider) ??
        LocaleType.fromLocal(context.locale);
    return IconButton(
      onPressed: () {
        final value =
            localeType == LocaleType.ja ? LocaleType.en : LocaleType.ja;
        ref.read(localeTypeControllerProvider.notifier).setState(value);
      },
      icon: Text(
        localeType == LocaleType.ja ? 'JP' : 'EN',
        style: context.largeStyle.copyWith(
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}
