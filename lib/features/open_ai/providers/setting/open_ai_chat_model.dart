import 'package:collection/collection.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/providers/shared_preferences.dart';

part 'open_ai_chat_model.g.dart';

/// https://platform.openai.com/docs/models/overview
enum OpenAIChatModelType {
  gpt4Turbo('gpt-4-turbo'),
  gpt4T0125Preview('gpt-4-0125-preview'),
  gpt35Turbo0125('gpt-3.5-turbo-0125'),
  gpt35Turbo('gpt-3.5-turbo'),
  ;

  const OpenAIChatModelType(this.value);
  final String value;
}

@riverpod
class OpenAIChatModel extends _$OpenAIChatModel {
  static const String key = 'open_ai_chat_model';

  @override
  OpenAIChatModelType build() {
    final value = ref.watch(sharedPreferencesProvider).getString(key);
    return OpenAIChatModelType.values
            .firstWhereOrNull((e) => e.value == value) ??
        OpenAIChatModelType.gpt35Turbo0125;
  }

  Future<void> save(OpenAIChatModelType model) async {
    await ref.read(sharedPreferencesProvider).setString(key, model.value);
    ref.invalidateSelf();
  }
}
