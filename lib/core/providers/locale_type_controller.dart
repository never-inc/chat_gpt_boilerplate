import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

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
  @override
  LocaleType? build() {
    return null;
  }

  // ignore: use_setters_to_change_properties
  void setState(LocaleType localeType) {
    state = localeType;
  }
}
