import '../../core/backend/backend.dart';
import '../../core/backend/backend_factory.dart';
import '../../core/backend/backend_kind.dart';
import 'db/app_database.dart';
import 'db/connection.dart';
import 'local_auth_provider.dart';
import 'local_labour_store.dart';
import 'local_market_cash_store.dart';
import 'local_market_store.dart';
import 'local_serial_meta_store.dart';
import 'local_shipment_store.dart';
import 'local_storage_provider.dart';
import 'seed/local_seed.dart';

/// Builds the on-device [Backend] (default). Opens the drift database, wires the
/// stores against the local session's uid, and seeds sample data for the first
/// account. Optionally accepts an injected [database] (for tests).
class LocalBackendFactory implements BackendFactory {
  LocalBackendFactory({AppDatabase? database}) : _injectedDb = database;

  final AppDatabase? _injectedDb;

  @override
  BackendKind get kind => BackendKind.local;

  @override
  Future<Backend> build() async {
    final db = _injectedDb ?? AppDatabase(openLocalDatabase());

    final auth = LocalAuthProvider(db);
    await auth.init();
    String uid() => auth.requireUid();

    final serialMeta = LocalSerialMetaStore(db: db, currentUid: uid);
    final markets = LocalMarketStore(db: db, currentUid: uid);
    final shipments = LocalShipmentStore(
      db: db,
      currentUid: uid,
      serialMeta: serialMeta,
    );
    final labour = LocalLabourStore(
      db: db,
      currentUid: uid,
      serialMeta: serialMeta,
    );
    final cash = LocalMarketCashStore(
      db: db,
      currentUid: uid,
      marketStore: markets,
    );
    final storage = LocalStorageProvider(currentUid: uid);

    auth.onFirstAccount = (_) => seedSampleData(
          markets: markets,
          shipments: shipments,
          labour: labour,
          cash: cash,
        );

    return Backend(
      kind: kind,
      auth: auth,
      shipments: shipments,
      markets: markets,
      marketCash: cash,
      labour: labour,
      serialMeta: serialMeta,
      storage: storage,
      onDispose: () async {
        await auth.close();
        await db.close();
      },
    );
  }
}
