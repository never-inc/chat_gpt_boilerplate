import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../extensions/context_extension.dart';
import '../providers/theme_mode_controller.dart';

class ThemeIcon extends ConsumerWidget {
  const ThemeIcon({this.color, super.key});

  final Color? color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeModeControllerProvider);
    final themeMode = theme == ThemeMode.system
        ? ThemeModeExtension.fromBrightness(context.platformBrightness)
        : theme;
    return IconButton(
      onPressed: () {
        final value =
            themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
        ref.read(themeModeControllerProvider.notifier).setState(value);
      },
      icon: Icon(
        themeMode == ThemeMode.dark ? Icons.dark_mode : Icons.light_mode,
        color: color,
      ),
    );
  }
}
