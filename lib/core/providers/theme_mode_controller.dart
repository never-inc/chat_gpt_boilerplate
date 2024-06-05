import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'shared_preferences.dart';

part 'theme_mode_controller.g.dart';

@riverpod
class ThemeModeController extends _$ThemeModeController {
  static const String key = 'theme_mode';

  @override
  ThemeMode build() {
    final value = ref.watch(sharedPreferencesProvider).getString(key);
    if (value == null) {
      return ThemeMode.system;
    }
    return ThemeMode.values.byName(value);
  }

  // ignore: use_setters_to_change_properties
  void setState(ThemeMode themeMode) {
    state = themeMode;
    ref.read(sharedPreferencesProvider).setString(key, themeMode.name);
  }
}

extension ThemeModeExtension on ThemeMode {
  static ThemeMode fromBrightness(Brightness brightness) =>
      switch (brightness) {
        (Brightness.light) => ThemeMode.light,
        (Brightness.dark) => ThemeMode.dark,
      };
}
