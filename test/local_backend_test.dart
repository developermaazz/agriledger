import 'package:agri_ledger/core/backend/backend.dart';
import 'package:agri_ledger/core/error/app_error.dart';
import 'package:agri_ledger/data/local/db/app_database.dart';
import 'package:agri_ledger/data/local/local_backend_factory.dart';
import 'package:agri_ledger/domain/record_status.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late Backend backend;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    backend = await LocalBackendFactory(database: db).build();
  });

  tearDown(() async {
    await backend.dispose();
  });

  test('not signed in throws NotSignedInError', () {
    expect(
      () => backend.markets.watchMarkets(),
      throwsA(isA<NotSignedInError>()),
    );
  });

  test('first anonymous sign-in seeds sample data', () async {
    await backend.auth.signInAnonymously();

    expect(await backend.markets.watchMarkets().first, hasLength(2));
    expect(await backend.shipments.watchShipments().first, hasLength(3));
    expect(await backend.labour.watchLabourJobs().first, hasLength(2));
  });

  test('shipment serial increments; balance & status derive from amounts',
      () async {
    await backend.auth.signInAnonymously(); // seeds 3 shipments (serials 1..3)

    final id = await backend.shipments.createShipment(
      date: DateTime.now(),
      marketId: 'x',
      marketName: 'X',
      buyerName: 'Buyer',
      quantity: 1,
      totalAmount: 100,
      amountReceived: 100,
      remarks: '',
    );

    final all = await backend.shipments.watchShipments().first;
    final created = all.firstWhere((s) => s.id == id);
    expect(created.serial, 4);
    expect(created.balance, 0);
    expect(created.status, RecordStatuses.completed);
  });

  test('completed shipment cannot be edited or deleted', () async {
    await backend.auth.signInAnonymously();
    final id = await backend.shipments.createShipment(
      date: DateTime.now(),
      marketId: 'x',
      marketName: 'X',
      buyerName: 'Buyer',
      quantity: 1,
      totalAmount: 100,
      amountReceived: 100,
      remarks: '',
    );
    final created =
        (await backend.shipments.watchShipments().first).firstWhere((s) => s.id == id);

    await expectLater(
      backend.shipments.deleteShipment(id),
      throwsA(isA<RecordLockedError>()),
    );
    await expectLater(
      backend.shipments.updateShipment(created),
      throwsA(isA<RecordLockedError>()),
    );
  });

  test('deleting a market referenced by a shipment is blocked', () async {
    await backend.auth.signInAnonymously();
    final markets = await backend.markets.watchMarkets().first;
    // "Downtown Market" is referenced by two seeded shipments.
    final downtown = markets.firstWhere((m) => m.name == 'Downtown Market');
    await expectLater(
      backend.markets.deleteMarket(downtown.id),
      throwsA(isA<MarketInUseError>()),
    );
  });

  test('cash entries form a carry-forward running-balance chain', () async {
    await backend.auth.signInAnonymously();
    final markets = await backend.markets.watchMarkets().first;
    final downtown = markets.firstWhere((m) => m.name == 'Downtown Market');

    final entries = await backend.marketCash.fetchCashEntriesOnce(downtown.id);
    expect(entries, isNotEmpty);

    var prev = 0.0;
    for (final e in entries) {
      expect(e.previousCash, prev);
      expect(e.cashAvailable, e.previousCash + e.amountReceived);
      expect(e.balance, e.cashAvailable - e.payments);
      prev = e.balance;
    }

    final latest = await backend.marketCash.latestBalanceForMarket(downtown.id);
    expect(latest, entries.last.balance);
  });

  test('anonymous and email accounts have separate data', () async {
    await backend.auth.signInAnonymously(); // first account -> seeded
    await backend.auth.signOut();
    await backend.auth.registerWithEmailPassword(
      email: 'a@b.com',
      password: 'secret1',
    );
    // Second account is not the first -> not seeded -> empty.
    expect(await backend.markets.watchMarkets().first, isEmpty);
  });
}
