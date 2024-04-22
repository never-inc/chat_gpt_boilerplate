import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../cache/cache_message.dart';
import '../cache/cache_messages.dart';
import '../open_ai/open_ai_chat.dart';
import '../open_ai/open_ai_image.dart';
import '../setting/chat_system_message.dart';
import '../setting/is_enabled_past_messages.dart';
import '../setting/open_ai_api_key.dart';
import '../setting/open_ai_chat_mode.dart';
import '../setting/open_ai_chat_model.dart';
import '../setting/open_ai_image_model.dart';
import 'fetch_messages.dart';
import 'message.dart';

part 'send_message.g.dart';

typedef State = ({bool isLoading});

@Riverpod(keepAlive: true)
class SendMessage extends _$SendMessage {
  @override
  State build() {
    return (isLoading: false);
  }

  Future<bool> call({
    required String text,
    required String roomId,
    void Function({required bool isSending})? onCall,
  }) async {
    onCall?.call(isSending: !state.isLoading);

    if (state.isLoading) {
      return false;
    }

    state = (isLoading: true);
    final messagesController = ref.read(fetchMessagesProvider.notifier);
    final cacheMessagesController = ref.read(cacheMessagesProvider);

    try {
      /// Save your message to cache
      final youMessage = TextMessage.create(
        roomId: roomId,
        text: text,
        userType: UserType.you,
      );
      await Future.wait([
        messagesController.addMessages([youMessage]),
        cacheMessagesController.save(youMessage.toCacheMessage()),
      ]);

      /// Check API Key
      final apiKey = ref.read(openAIAPIKeyProvider);
      if (apiKey == null || apiKey.isEmpty) {
        throw Exception(
          'Invalid API Key. Please set the AI API Key in Settings.',
        );
      }

      /// Show Loading
      await messagesController.addMessages([Loading.create()]);

      /// Inquiry AI
      final chatMode = ref.read(openAIChatModeProvider);
      switch (chatMode) {
        /// Text
        case OpenAIChatModeType.text:
          final systemMessageText = ref.read(chatSystemMessageProvider);

          final List<CacheMessage> caches;
          if (ref.read(isEnabledPastMessagesProvider)) {
            caches = await ref.read(cacheMessagesProvider).fetch(
                  offset: 0,
                  limit: 100,
                );
          } else {
            caches = [];
          }

          final chatModel = ref.read(openAIChatModelProvider);
          final completion = await ref.read(openAIChatProvider).create(
                text: text,
                apiKey: apiKey,
                model: chatModel.value,
                previousMessages: caches.map(TextMessage.fromCache).toList(),
                systemMessageText: systemMessageText,
              );

          if (completion == null) {
            throw Exception('Not generated.');
          }

          final robotText = completion
                  .choices.firstOrNull?.message.content?.firstOrNull?.text ??
              'unknown';
          final robotMessage = TextMessage.create(
            roomId: roomId,
            messageId: completion.id,
            text: robotText,
            userType: UserType.robot,
          );
          await Future.wait([
            messagesController.addMessages([robotMessage]),
            cacheMessagesController.save(robotMessage.toCacheMessage()),
          ]);

        /// Image
        case OpenAIChatModeType.image:
          final imageModel = ref.read(openAIImageModelProvider);
          final completion = await ref.read(openAIImageProvider).create(
                prompt: text,
                apiKey: apiKey,
                model: imageModel.value,
              );
          if (completion == null) {
            throw Exception('Not generated.');
          }

          final robotMessage = TextMessage.create(
            roomId: roomId,
            userType: UserType.robot,
            images: completion.data
                .map(
                  (e) => ImageData(
                    url: e.url,
                    revisedPrompt: e.revisedPrompt,
                  ),
                )
                .toList(),
          );
          await Future.wait([
            messagesController.addMessages([robotMessage]),
            cacheMessagesController.save(robotMessage.toCacheMessage()),
          ]);
      }

      return true;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    } finally {
      await messagesController.removeLoading();
      state = (isLoading: false);
    }
  }
}
