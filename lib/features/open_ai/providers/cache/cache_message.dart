import 'package:isar/isar.dart';

part 'cache_message.g.dart';

@collection
@Name('CacheMessage')
class CacheMessage {
  CacheMessage({
    required this.roomId,
    required this.messageId,
    required this.userType,
    required this.createdAt,
    this.text,
    this.images,
  });

  final Id id = Isar.autoIncrement;
  final String roomId;
  final String messageId;
  final String? text;
  final String userType;
  final List<String>? images;

  @Index()
  final DateTime createdAt;
}
