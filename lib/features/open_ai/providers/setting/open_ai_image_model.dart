import 'package:collection/collection.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/providers/shared_preferences.dart';

part 'open_ai_image_model.g.dart';

/// https://platform.openai.com/docs/models/overview
enum OpenAIImageModelType {
  dallE3('dall-e-3'),
  dallE2('dall-e-2'),
  ;

  const OpenAIImageModelType(this.value);
  final String value;
}

@riverpod
class OpenAIImageModel extends _$OpenAIImageModel {
  static const String key = 'open_ai_image_model';

  @override
  OpenAIImageModelType build() {
    final value = ref.watch(sharedPreferencesProvider).getString(key);
    return OpenAIImageModelType.values
            .firstWhereOrNull((e) => e.value == value) ??
        OpenAIImageModelType.dallE3;
  }

  Future<void> save(OpenAIImageModelType model) async {
    await ref.read(sharedPreferencesProvider).setString(key, model.value);
    ref.invalidateSelf();
  }
}
