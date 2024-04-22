import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../cache/cache_messages.dart';
import 'message.dart';

part 'fetch_messages.g.dart';

@riverpod
class FetchMessages extends _$FetchMessages {
  @override
  Future<List<Message>> build() async {
    final caches = await ref.watch(cacheMessagesProvider).fetch(
          offset: 0,
          limit: Message.pageSize,
          isDesc: true,
        );

    final List<Message> result;
    if (caches.isEmpty) {
      result = [WelcomeMessage.create()];
    } else {
      result = caches.map(TextMessage.fromCache).toList();
    }

    return result;
  }

  Future<void> fetchMore() async {
    final oldData = await future;
    final offset = oldData.whereType<TextMessage>().length;
    final caches = await ref.read(cacheMessagesProvider).fetch(
          offset: offset,
          limit: Message.pageSize,
          isDesc: true,
        );
    if (caches.isEmpty) {
      return;
    }
    state = AsyncData(
      [
        ...oldData,
        ...caches.map(TextMessage.fromCache),
      ],
    );
  }

  Future<void> addMessages(List<Message> messages) async {
    final oldData = await future;
    final result = [...messages, ...oldData];
    state = AsyncData(result);
  }

  Future<void> removeLoading() async {
    final oldData = await future;
    final result = oldData.where((element) => element is! Loading).toList();
    state = AsyncData(result);
  }
}
