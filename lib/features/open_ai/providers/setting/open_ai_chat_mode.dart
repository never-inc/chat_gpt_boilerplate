import 'package:collection/collection.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/providers/shared_preferences.dart';

part 'open_ai_chat_mode.g.dart';

enum OpenAIChatModeType {
  text('Text'),
  image('Image'),
  ;

  const OpenAIChatModeType(this.value);
  final String value;
}

@riverpod
class OpenAIChatMode extends _$OpenAIChatMode {
  static const String key = 'open_ai_chat_mode';

  @override
  OpenAIChatModeType build() {
    final value = ref.watch(sharedPreferencesProvider).getString(key);
    return OpenAIChatModeType.values
            .firstWhereOrNull((e) => e.value == value) ??
        OpenAIChatModeType.text;
  }

  Future<void> save(OpenAIChatModeType modeType) async {
    await ref.read(sharedPreferencesProvider).setString(key, modeType.value);
    ref.invalidateSelf();
  }
}
