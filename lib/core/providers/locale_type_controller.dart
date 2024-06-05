import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'shared_preferences.dart';

part 'locale_type_controller.g.dart';

enum LocaleType {
  en('en'),
  ja('ja'),
  ;

  const LocaleType(this.languageCode);
  static LocaleType fromLocal(Locale locale) => switch (locale.languageCode) {
        ('ja') => LocaleType.ja,
        _ => LocaleType.en,
      };

  final String languageCode;

  Locale get toLocale => Locale(languageCode);
}

@riverpod
class LocaleTypeController extends _$LocaleTypeController {
  static const String key = 'language_code';

  @override
  LocaleType? build() {
    final value = ref.watch(sharedPreferencesProvider).getString(key);
    if (value == null) {
      return null;
    }
    return LocaleType.values.firstWhereOrNull((e) => e.languageCode == value);
  }

  // ignore: use_setters_to_change_properties
  void setState(LocaleType localeType) {
    state = localeType;
    ref.read(sharedPreferencesProvider).setString(key, localeType.languageCode);
  }
}
