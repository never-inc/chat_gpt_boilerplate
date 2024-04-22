import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/providers/shared_preferences.dart';

part 'open_ai_api_key.g.dart';

@riverpod
class OpenAIAPIKey extends _$OpenAIAPIKey {
  static const String key = 'open_ai_api_key';

  @override
  String? build() {
    return ref.watch(sharedPreferencesProvider).getString(key);
  }

  Future<void> save(String value) async {
    await ref.read(sharedPreferencesProvider).setString(key, value);
    ref.invalidateSelf();
  }
}
