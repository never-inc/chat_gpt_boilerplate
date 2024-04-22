import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:uuid/v4.dart';

import '../../../../core/extensions/date_time_extension.dart';
import '../cache/cache_message.dart';

/// Chat message entities
sealed class Message {
  const Message(
    this.messageId,
    this.date,
  );

  static const pageSize = 20;
  static const roomId = '0';

  static DateTime? getDateTile(int index, List<DateTime> dateTimes) {
    if (dateTimes.isEmpty) {
      return null;
    }

    if (dateTimes.length <= index + 1) {
      return dateTimes[index];
    }
    final lastDateTime = dateTimes[index].setHour(0, 0, 0, 0, 0);
    final nextDateTime = dateTimes[index + 1].setHour(0, 0, 0, 0, 0);
    return lastDateTime != nextDateTime ? dateTimes[index] : null;
  }

  final String messageId;
  final DateTime date;
}

class TextMessage implements Message {
  const TextMessage({
    required this.roomId,
    required this.messageId,
    required this.date,
    required this.userType,
    this.text,
    this.images,
  });

  factory TextMessage.create({
    required String roomId,
    required UserType userType,
    String? text,
    String? messageId,
    DateTime? date,
    List<ImageData>? images,
  }) =>
      TextMessage(
        roomId: roomId,
        messageId: messageId ?? const UuidV4().generate(),
        date: date ?? DateTime.now(),
        userType: userType,
        text: text,
        images: images,
      );

  factory TextMessage.fromCache(CacheMessage cache) => TextMessage(
        roomId: cache.roomId,
        messageId: cache.messageId,
        text: cache.text,
        date: cache.createdAt,
        userType:
            UserType.values.firstWhereOrNull((e) => e.name == cache.userType) ??
                UserType.robot,
        images: cache.images?.map((e) {
          final data = json.decode(e) as Map<String, dynamic>;
          return ImageData(
            url: data['url'] as String?,
            revisedPrompt: data['revisedPrompt'] as String?,
          );
        }).toList(),
      );

  CacheMessage toCacheMessage() => CacheMessage(
        roomId: roomId,
        messageId: messageId,
        createdAt: date,
        userType: userType.name,
        text: text,
        images: images
            ?.map(
              (e) => json.encode(<String, dynamic>{
                'url': e.url,
                'revisedPrompt': e.revisedPrompt,
              }),
            )
            .toList(),
      );

  final String roomId;
  @override
  final String messageId;
  final String? text;
  @override
  final DateTime date;
  final UserType userType;
  final List<ImageData>? images;
}

class WelcomeMessage implements Message {
  const WelcomeMessage({
    required this.messageId,
    required this.date,
  });

  factory WelcomeMessage.create({
    String? messageId,
    DateTime? date,
  }) =>
      WelcomeMessage(
        messageId: messageId ?? const UuidV4().generate(),
        date: date ?? DateTime.now(),
      );

  @override
  final String messageId;

  @override
  final DateTime date;
}

class Loading implements Message {
  const Loading({
    required this.messageId,
    required this.date,
  });

  factory Loading.create({
    String? messageId,
    DateTime? date,
  }) =>
      Loading(
        messageId: messageId ?? const UuidV4().generate(),
        date: date ?? DateTime.now(),
      );

  @override
  final String messageId;

  @override
  final DateTime date;
}

/// Field type
enum UserType {
  robot('robot'),
  you('you'),
  ;

  const UserType(this.name);
  final String name;
}

class ImageData {
  ImageData({
    this.url,
    this.revisedPrompt,
  });
  final String? url;
  final String? revisedPrompt;
}
