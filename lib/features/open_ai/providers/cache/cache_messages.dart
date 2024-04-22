import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/providers/isar.dart';
import 'cache_message.dart';

part 'cache_messages.g.dart';

@Riverpod(keepAlive: true)
CacheMessages cacheMessages(
  CacheMessagesRef ref,
) {
  return CacheMessages(ref);
}

class CacheMessages {
  CacheMessages(this._ref);

  final CacheMessagesRef _ref;

  Isar get _db => _ref.read(isarProvider);

  Future<List<CacheMessage>> fetch({
    required int offset,
    required int limit,
    bool isDesc = false,
  }) async {
    final List<CacheMessage> result;
    if (isDesc) {
      result = await _db.cacheMessages
          .where()
          .sortByCreatedAtDesc()
          .offset(offset)
          .limit(limit)
          .findAll();
    } else {
      result = await _db.cacheMessages
          .where()
          .sortByCreatedAt()
          .offset(offset)
          .limit(limit)
          .findAll();
    }

    return result;
  }

  Future<int> save(CacheMessage data) async {
    final result = await _db.writeTxn(() async {
      return _db.cacheMessages.put(data);
    });
    return result;
  }

  Future<void> clear() async {
    final result = await _db.writeTxn(() async {
      return _db.cacheMessages.clear();
    });
    return result;
  }
}
