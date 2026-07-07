import 'package:agri_ledger/data/local/db/app_database.dart';
import 'package:agri_ledger/data/local/local_backend_factory.dart';
import 'package:agri_ledger/data/migration/migration_service.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('export then import round-trips all data into a fresh backend', () async {
    // Source: a seeded local backend.
    final srcDb = AppDatabase(NativeDatabase.memory());
    final src = await LocalBackendFactory(database: srcDb).build();
    await src.auth.signInAnonymously(); // first account -> seeded

    final srcMigration = MigrationService(
      markets: src.markets,
      shipments: src.shipments,
      labour: src.labour,
      marketCash: src.marketCash,
    );
    final json = await srcMigration.exportToJson();

    // Target: a clean (empty) local backend.
    final dstDb = AppDatabase(NativeDatabase.memory());
    final dst = await LocalBackendFactory(database: dstDb).build();
    await dst.auth.signInAnonymously();
    await dst.auth.signOut();
    await dst.auth.signInAnonymously(); // second account -> empty

    final dstMigration = MigrationService(
      markets: dst.markets,
      shipments: dst.shipments,
      labour: dst.labour,
      marketCash: dst.marketCash,
    );
    final summary = await dstMigration.importFromJson(json);

    expect(summary.markets, 2);
    expect(summary.shipments, 3);
    expect(summary.labour, 2);
    expect(summary.cash, 3);

    // Data landed with names and totals preserved.
    final dstMarkets = await dst.markets.watchMarkets().first;
    expect(
      dstMarkets.map((m) => m.name).toSet(),
      {'Downtown Market', 'Riverside Market'},
    );

    final srcShipments = await src.shipments.watchShipments().first;
    final dstShipments = await dst.shipments.watchShipments().first;
    double total(Iterable<num> xs) => xs.fold(0.0, (a, b) => a + b);
    expect(
      total(dstShipments.map((s) => s.totalAmount)),
      total(srcShipments.map((s) => s.totalAmount)),
    );

    await src.dispose();
    await dst.dispose();
  });
}
