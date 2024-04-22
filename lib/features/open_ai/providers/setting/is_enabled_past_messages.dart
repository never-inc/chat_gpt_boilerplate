import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/providers/shared_preferences.dart';

part 'is_enabled_past_messages.g.dart';

@riverpod
class IsEnabledPastMessages extends _$IsEnabledPastMessages {
  static const String key = 'is_enabled_past_messages';

  @override
  bool build() {
    return ref.watch(sharedPreferencesProvider).getBool(key) ?? true;
  }

  Future<void> save({
    required bool value,
  }) async {
    await ref.read(sharedPreferencesProvider).setBool(key, value);
    ref.invalidateSelf();
  }
}
