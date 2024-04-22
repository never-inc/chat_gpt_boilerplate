import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/providers/shared_preferences.dart';

part 'chat_system_message.g.dart';

@riverpod
class ChatSystemMessage extends _$ChatSystemMessage {
  static const String key = 'chat_system_message';

  @override
  String? build() {
    return ref.watch(sharedPreferencesProvider).getString(key);
  }

  Future<void> save(String value) async {
    await ref.read(sharedPreferencesProvider).setString(key, value);
    ref.invalidateSelf();
  }
}
