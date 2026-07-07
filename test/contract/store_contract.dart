import 'package:agri_ledger/core/backend/backend.dart';
import 'package:agri_ledger/core/error/app_error.dart';
import 'package:agri_ledger/domain/record_status.dart';
import 'package:flutter_test/flutter_test.dart';

/// Backend-agnostic contract. The SAME assertions run against every backend
/// (local + firebase-fake) to prove the implementations are interchangeable.
///
/// [makeBackend] must return a signed-in backend with NO pre-existing data.
void runStoreContractTests(
  String label,
  Future<Backend> Function() makeBackend,
) {
  group('[$label] store contract', () {
    late Backend b;

    setUp(() async {
      b = await makeBackend();
    });

    tearDown(() async {
      await b.dispose();
    });

    test('markets: create, watch ordered by name asc, rename, delete',
        () async {
      await b.markets.createMarket('Zeta');
      await b.markets.createMarket('Alpha');

      var markets = await b.markets.watchMarkets().first;
      expect(markets.map((m) => m.name).toList(), ['Alpha', 'Zeta']);

      final alpha = markets.firstWhere((m) => m.name == 'Alpha');
      await b.markets.updateMarketName(alpha.id, 'Beta');
      markets = await b.markets.watchMarkets().first;
      expect(markets.map((m) => m.name).toList(), ['Beta', 'Zeta']);

      final zeta = markets.firstWhere((m) => m.name == 'Zeta');
      await b.markets.deleteMarket(zeta.id);
      markets = await b.markets.watchMarkets().first;
      expect(markets.map((m) => m.name).toList(), ['Beta']);
    });

    test('shipments: serial increments; balance/status derive; date desc order',
        () async {
      final mId = await b.markets.createMarket('M');
      final s1 = await b.shipments.createShipment(
        date: DateTime(2024, 1, 1),
        marketId: mId,
        marketName: 'M',
        buyerName: 'A',
        quantity: 1,
        totalAmount: 100,
        amountReceived: 40,
        remarks: '',
      );
      final s2 = await b.shipments.createShipment(
        date: DateTime(2024, 2, 1),
        marketId: mId,
        marketName: 'M',
        buyerName: 'B',
        quantity: 1,
        totalAmount: 50,
        amountReceived: 50,
        remarks: '',
      );

      final list = await b.shipments.watchShipments().first;
      // Newest (Feb, serial 2) first.
      expect(list.map((s) => s.serial).toList(), [2, 1]);

      final pending = list.firstWhere((s) => s.id == s1);
      expect(pending.serial, 1);
      expect(pending.balance, 60);
      expect(pending.status, RecordStatuses.pending);

      final completed = list.firstWhere((s) => s.id == s2);
      expect(completed.balance, 0);
      expect(completed.status, RecordStatuses.completed);
    });

    test('completed shipment cannot be edited or deleted', () async {
      final mId = await b.markets.createMarket('M');
      final id = await b.shipments.createShipment(
        date: DateTime(2024, 1, 1),
        marketId: mId,
        marketName: 'M',
        buyerName: 'A',
        quantity: 1,
        totalAmount: 100,
        amountReceived: 100,
        remarks: '',
      );
      final s =
          (await b.shipments.watchShipments().first).firstWhere((e) => e.id == id);

      await expectLater(
        b.shipments.deleteShipment(id),
        throwsA(isA<RecordLockedError>()),
      );
      await expectLater(
        b.shipments.updateShipment(s),
        throwsA(isA<RecordLockedError>()),
      );
    });

    test('a market referenced by a shipment cannot be deleted', () async {
      final mId = await b.markets.createMarket('M');
      await b.shipments.createShipment(
        date: DateTime(2024, 1, 1),
        marketId: mId,
        marketName: 'M',
        buyerName: 'A',
        quantity: 1,
        totalAmount: 100,
        amountReceived: 40,
        remarks: '',
      );
      await expectLater(
        b.markets.deleteMarket(mId),
        throwsA(isA<MarketInUseError>()),
      );
    });

    test('labour serial is independent from shipment serial', () async {
      final mId = await b.markets.createMarket('M');
      await b.shipments.createShipment(
        date: DateTime(2024, 1, 1),
        marketId: mId,
        marketName: 'M',
        buyerName: 'A',
        quantity: 1,
        totalAmount: 10,
        amountReceived: 1,
        remarks: '',
      );
      final jId = await b.labour.createLabourJob(
        dateStart: DateTime(2024, 1, 1),
        dateEnd: DateTime(2024, 1, 2),
        totalCost: 100,
        receivedPayment: 30,
        remarks: '',
      );

      final job =
          (await b.labour.watchLabourJobs().first).firstWhere((j) => j.id == jId);
      expect(job.serial, 1); // labour counter is separate
      expect(job.remainingBalance, 70);
      expect(job.status, RecordStatuses.pending);
    });

    test('cash: carry-forward chain, recompute on edit and delete', () async {
      final mId = await b.markets.createMarket('M');
      await b.marketCash.createCashEntry(
        marketId: mId,
        date: DateTime(2024, 1, 1),
        amountReceived: 100,
        payments: 30,
        remarks: '',
      );
      await b.marketCash.createCashEntry(
        marketId: mId,
        date: DateTime(2024, 1, 2),
        amountReceived: 50,
        payments: 20,
        remarks: '',
      );

      var entries = await b.marketCash.fetchCashEntriesOnce(mId);
      expect(entries.map((e) => e.serial).toList(), [1, 2]);
      expect(entries[0].previousCash, 0);
      expect(entries[0].cashAvailable, 100);
      expect(entries[0].balance, 70);
      expect(entries[1].previousCash, 70);
      expect(entries[1].cashAvailable, 120);
      expect(entries[1].balance, 100);
      expect(await b.marketCash.latestBalanceForMarket(mId), 100);

      // Edit the first entry -> whole chain recomputes.
      await b.marketCash.updateCashEntryRaw(
        marketId: mId,
        entryId: entries[0].id,
        date: entries[0].date,
        amountReceived: 200,
        payments: 30,
        remarks: '',
      );
      entries = await b.marketCash.fetchCashEntriesOnce(mId);
      expect(entries[0].balance, 170);
      expect(entries[1].previousCash, 170);
      expect(entries[1].balance, 200);

      // Delete the first entry -> chain recomputes from zero.
      await b.marketCash.deleteCashEntry(mId, entries[0].id);
      entries = await b.marketCash.fetchCashEntriesOnce(mId);
      expect(entries, hasLength(1));
      expect(entries[0].previousCash, 0);
      expect(entries[0].balance, 30); // 50 - 20
    });

    test('per-market latest balance sums for the dashboard total', () async {
      final m1 = await b.markets.createMarket('A');
      final m2 = await b.markets.createMarket('B');
      await b.marketCash.createCashEntry(
        marketId: m1,
        date: DateTime(2024, 1, 1),
        amountReceived: 100,
        payments: 0,
        remarks: '',
      );
      await b.marketCash.createCashEntry(
        marketId: m2,
        date: DateTime(2024, 1, 1),
        amountReceived: 40,
        payments: 10,
        remarks: '',
      );
      expect(await b.marketCash.latestBalanceForMarket(m1), 100);
      expect(await b.marketCash.latestBalanceForMarket(m2), 30);
    });
  });
}
