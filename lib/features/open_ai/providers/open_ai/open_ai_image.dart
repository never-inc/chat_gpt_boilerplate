import 'package:dart_openai/dart_openai.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'open_ai_image.g.dart';

@Riverpod(keepAlive: true)
OpenAIImage openAIImage(
  OpenAIImageRef ref,
) {
  return OpenAIImage();
}

class OpenAIImage {
  Future<OpenAIImageModel?> create({
    required String prompt,
    required String apiKey,
    required String model,
  }) async {
    OpenAI.apiKey = apiKey;
    OpenAI.showLogs = true;

    final completion = await OpenAI.instance.image.create(
      model: model,
      prompt: prompt,
    );
    return completion;
  }
}
