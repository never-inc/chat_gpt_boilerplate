import 'package:dart_openai/dart_openai.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../message/message.dart';

part 'open_ai_chat.g.dart';

@Riverpod(keepAlive: true)
OpenAIChat openAIChat(
  OpenAIChatRef ref,
) {
  return OpenAIChat();
}

class OpenAIChat {
  Future<OpenAIChatCompletionModel?> create({
    required String text,
    required String apiKey,
    required String model,
    List<TextMessage>? previousMessages,
    String? systemMessageText,
  }) async {
    OpenAI.apiKey = apiKey;
    OpenAI.showLogs = true;

    /// System Message
    final systemMessage =
        systemMessageText != null && systemMessageText.isNotEmpty
            ? OpenAIChatCompletionChoiceMessageModel(
                content: [
                  OpenAIChatCompletionChoiceMessageContentItemModel.text(
                    systemMessageText,
                  ),
                ],
                role: OpenAIChatMessageRole.system,
              )
            : null;

    /// Context Messages
    final contextMessages =
        previousMessages?.where((element) => element.text != null).map((e) {
      return OpenAIChatCompletionChoiceMessageModel(
        content: [
          OpenAIChatCompletionChoiceMessageContentItemModel.text(e.text ?? ''),
        ],
        role: e.userType == UserType.robot
            ? OpenAIChatMessageRole.assistant
            : OpenAIChatMessageRole.user,
      );
    }).toList();

    /// Latest Message
    final latestUserMessage = OpenAIChatCompletionChoiceMessageModel(
      content: [
        OpenAIChatCompletionChoiceMessageContentItemModel.text(text),
      ],
      role: OpenAIChatMessageRole.user,
    );

    final completion = await OpenAI.instance.chat.create(
      model: model,
      messages: [
        if (systemMessage != null) systemMessage,
        if (contextMessages != null) ...contextMessages,
        latestUserMessage,
      ],
    );
    return completion;
  }
}
