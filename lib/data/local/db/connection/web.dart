import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';

/// Opens the database on web via WebAssembly SQLite.
///
/// Requires `sqlite3.wasm` and `drift_worker.js` to be present in the app's
/// `web/` directory (see README — fetch them for the drift version in use).
QueryExecutor openLocalDatabase() {
  return LazyDatabase(() async {
    final result = await WasmDatabase.open(
      databaseName: 'agri_ledger',
      sqlite3Uri: Uri.parse('sqlite3.wasm'),
      driftWorkerUri: Uri.parse('drift_worker.js'),
    );
    return result.resolvedExecutor;
  });
}
