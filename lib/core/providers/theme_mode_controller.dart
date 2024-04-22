import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme_mode_controller.g.dart';

@riverpod
class ThemeModeController extends _$ThemeModeController {
  @override
  ThemeMode build() {
    return ThemeMode.system;
  }

  // ignore: use_setters_to_change_properties
  void setState(ThemeMode themeMode) {
    state = themeMode;
  }
}

extension ThemeModeExtension on ThemeMode {
  static ThemeMode fromBrightness(Brightness brightness) =>
      switch (brightness) {
        (Brightness.light) => ThemeMode.light,
        (Brightness.dark) => ThemeMode.dark,
      };
}
