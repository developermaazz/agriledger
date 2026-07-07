import 'dart:async';

import 'package:drift/drift.dart';

import '../../domain/cash_ledger_math.dart';
import '../../domain/entities/cash_activity_line.dart';
import '../../domain/entities/cash_entry.dart';
import '../../domain/entities/market.dart';
import '../../domain/repositories/market_cash_store.dart';
import '../../domain/repositories/market_store.dart';
import 'db/app_database.dart';
import 'local_ids.dart';
import 'mappers/local_mappers.dart';

/// Local [MarketCashStore]. Cash entries scoped by `ownerUid` + `marketId`,
/// ordered by date then serial, with running-balance recompute after every
/// mutation and cross-market dashboard aggregations.
class LocalMarketCashStore implements MarketCashStore {
  LocalMarketCashStore({
    required this.db,
    required this.currentUid,
    required this.marketStore,
  });

  final AppDatabase db;
  final String Function() currentUid;
  final MarketStore marketStore;

  int get _now => DateTime.now().millisecondsSinceEpoch;

  SimpleSelectStatement<$CashEntriesTable, CashEntryRow> _orderedFor(
      String marketId) {
    final uid = currentUid();
    return db.select(db.cashEntries)
      ..where((t) => t.ownerUid.equals(uid) & t.marketId.equals(marketId))
      ..orderBy([
        (t) => OrderingTerm.asc(t.date),
        (t) => OrderingTerm.asc(t.serial),
      ]);
  }

  @override
  Stream<List<CashEntry>> watchCashEntries(String marketId) {
    return _orderedFor(marketId)
        .watch()
        .map((rows) => rows.map(cashEntryFromRow).toList());
  }

  @override
  Future<void> refreshCashEntriesFromServer(String marketId) async {}

  @override
  Future<List<CashEntry>> fetchCashEntriesOnce(String marketId) async {
    final rows = await _orderedFor(marketId).get();
    return rows.map(cashEntryFromRow).toList();
  }

  @override
  Future<String> createCashEntry({
    required String marketId,
    required DateTime date,
    required double amountReceived,
    required double payments,
    required String remarks,
  }) async {
    final uid = currentUid();
    final serial = await marketStore.allocateCashSerial(marketId);
    final id = newLocalId();
    final now = _now;
    await db.into(db.cashEntries).insert(
          CashEntriesCompanion.insert(
            id: id,
            ownerUid: uid,
            marketId: marketId,
            serial: serial,
            date: date.millisecondsSinceEpoch,
            amountReceived: amountReceived,
            payments: payments,
            previousCash: 0,
            cashAvailable: 0,
            balance: 0,
            remarks: remarks,
            createdAt: Value(now),
            updatedAt: Value(now),
          ),
        );
    await recomputeChain(marketId);
    return id;
  }

  @override
  Future<void> updateCashEntryRaw({
    required String marketId,
    required String entryId,
    required DateTime date,
    required double amountReceived,
    required double payments,
    required String remarks,
  }) async {
    await (db.update(db.cashEntries)..where((t) => t.id.equals(entryId))).write(
      CashEntriesCompanion(
        date: Value(date.millisecondsSinceEpoch),
        amountReceived: Value(amountReceived),
        payments: Value(payments),
        remarks: Value(remarks),
        updatedAt: Value(_now),
      ),
    );
    await recomputeChain(marketId);
  }

  @override
  Future<void> deleteCashEntry(String marketId, String entryId) async {
    await (db.delete(db.cashEntries)..where((t) => t.id.equals(entryId))).go();
    await recomputeChain(marketId);
  }

  @override
  Future<void> recomputeChain(String marketId) async {
    await db.transaction(() async {
      final rows = await _orderedFor(marketId).get();
      final entries = rows.map(cashEntryFromRow).toList();
      final computed = recomputeCashChain(entries);
      final now = _now;
      for (final e in computed) {
        await (db.update(db.cashEntries)..where((t) => t.id.equals(e.id)))
            .write(
          CashEntriesCompanion(
            previousCash: Value(e.previousCash),
            cashAvailable: Value(e.cashAvailable),
            balance: Value(e.balance),
            updatedAt: Value(now),
          ),
        );
      }
      await (db.update(db.markets)..where((t) => t.id.equals(marketId))).write(
        MarketsCompanion(updatedAt: Value(now)),
      );
    });
  }

  @override
  Future<double> latestBalanceForMarket(String marketId) async {
    final uid = currentUid();
    final row = await (db.select(db.cashEntries)
          ..where((t) => t.ownerUid.equals(uid) & t.marketId.equals(marketId))
          ..orderBy([
            (t) => OrderingTerm.desc(t.date),
            (t) => OrderingTerm.desc(t.serial),
          ])
          ..limit(1))
        .getSingleOrNull();
    return row?.balance ?? 0;
  }

  @override
  Stream<double> watchDashboardTotalCash() {
    return marketStore.watchMarkets().asyncExpand((markets) {
      if (markets.isEmpty) {
        return Stream<double>.value(0);
      }
      return _watchTotalCashForMarkets(markets);
    });
  }

  Stream<double> _watchTotalCashForMarkets(List<Market> markets) {
    final subs = <StreamSubscription<List<CashEntry>>>[];
    late final StreamController<double> controller;
    controller = StreamController<double>(
      onListen: () {
        Future<void> push() async {
          var sum = 0.0;
          for (final m in markets) {
            sum += await latestBalanceForMarket(m.id);
          }
          if (!controller.isClosed) {
            controller.add(sum);
          }
        }

        for (final m in markets) {
          subs.add(watchCashEntries(m.id).listen((_) => push()));
        }
        push();
      },
      onCancel: () {
        for (final s in subs) {
          s.cancel();
        }
      },
    );
    return controller.stream;
  }

  @override
  Stream<List<CashActivityLine>> watchCashActivityFeed() {
    return marketStore.watchMarkets().asyncExpand((markets) {
      if (markets.isEmpty) {
        return Stream<List<CashActivityLine>>.value([]);
      }
      return _watchCashActivityForMarkets(markets);
    });
  }

  Stream<List<CashActivityLine>> _watchCashActivityForMarkets(
      List<Market> markets) {
    final subs = <StreamSubscription<List<CashEntry>>>[];
    final cache = <String, List<CashEntry>>{};
    late final StreamController<List<CashActivityLine>> controller;
    controller = StreamController<List<CashActivityLine>>(
      onListen: () {
        void emit() {
          final rows = <CashActivityLine>[];
          for (final m in markets) {
            for (final e in cache[m.id] ?? const []) {
              rows.add(CashActivityLine(marketName: m.name, entry: e));
            }
          }
          rows.sort((a, b) {
            final ta = a.entry.updatedAt ?? a.entry.date;
            final tb = b.entry.updatedAt ?? b.entry.date;
            return tb.compareTo(ta);
          });
          if (!controller.isClosed) {
            controller.add(rows.take(12).toList());
          }
        }

        for (final m in markets) {
          subs.add(watchCashEntries(m.id).listen((list) {
            cache[m.id] = list;
            emit();
          }));
        }
      },
      onCancel: () {
        for (final s in subs) {
          s.cancel();
        }
      },
    );
    return controller.stream;
  }
}
