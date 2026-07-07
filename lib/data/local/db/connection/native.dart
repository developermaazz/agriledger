import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Opens the on-device SQLite database file in the app documents directory
/// (mobile, desktop, and headless `flutter test` on the Dart VM).
QueryExecutor openLocalDatabase() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'agri_ledger.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
