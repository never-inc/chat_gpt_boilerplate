import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'core/providers/isar.dart';
import 'core/providers/shared_preferences.dart';
import 'features/open_ai/providers/cache/cache_message.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  late final SharedPreferences sharedPreferences;
  late final Isar isar;
  await Future.wait([
    Future(() async {
      sharedPreferences = await SharedPreferences.getInstance();
    }),
    Future(() async {
      final dir = await getApplicationDocumentsDirectory();
      isar = await Isar.open(
        [CacheMessageSchema],
        directory: dir.path,
      );
    }),
  ]);

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
        isarProvider.overrideWithValue(isar),
      ],
      child: const App(),
    ),
  );
}
