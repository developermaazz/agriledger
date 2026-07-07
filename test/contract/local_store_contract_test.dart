import 'package:agri_ledger/core/backend/backend.dart';
import 'package:agri_ledger/data/local/db/app_database.dart';
import 'package:agri_ledger/data/local/local_backend_factory.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'store_contract.dart';

/// Runs the shared store contract against the LOCAL (drift) backend.
Future<Backend> _makeLocalEmpty() async {
  final db = AppDatabase(NativeDatabase.memory());
  final backend = await LocalBackendFactory(database: db).build();
  // First anonymous account seeds sample data; sign out and sign in again so
  // the contract runs against a clean, empty account.
  await backend.auth.signInAnonymously();
  await backend.auth.signOut();
  await backend.auth.signInAnonymously();
  return backend;
}

void main() {
  runStoreContractTests('local', _makeLocalEmpty);
}
