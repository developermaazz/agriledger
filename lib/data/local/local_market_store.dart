import 'package:drift/drift.dart';

import '../../core/error/app_error.dart';
import '../../domain/entities/market.dart';
import '../../domain/repositories/market_store.dart';
import 'db/app_database.dart';
import 'local_ids.dart';
import 'mappers/local_mappers.dart';

/// Local [MarketStore]. Markets are scoped by `ownerUid`, ordered by name asc.
class LocalMarketStore implements MarketStore {
  LocalMarketStore({required this.db, required this.currentUid});

  final AppDatabase db;
  final String Function() currentUid;

  @override
  Stream<List<Market>> watchMarkets() {
    final uid = currentUid();
    return (db.select(db.markets)
          ..where((t) => t.ownerUid.equals(uid))
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .watch()
        .map((rows) => rows.map(marketFromRow).toList());
  }

  @override
  Future<void> refreshFromServer() async {
    // Local store is the source of truth — nothing to refresh.
  }

  @override
  Future<String> createMarket(String name) async {
    final uid = currentUid();
    final id = newLocalId();
    final now = DateTime.now().millisecondsSinceEpoch;
    await db.into(db.markets).insert(
          MarketsCompanion.insert(
            id: id,
            ownerUid: uid,
            name: name.trim(),
            cashSerialNext: const Value(1),
            createdAt: Value(now),
            updatedAt: Value(now),
          ),
        );
    return id;
  }

  @override
  Future<void> updateMarketName(String id, String name) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    await (db.update(db.markets)..where((t) => t.id.equals(id))).write(
      MarketsCompanion(name: Value(name.trim()), updatedAt: Value(now)),
    );
  }

  @override
  Future<void> deleteMarket(
    String marketId, {
    bool deleteCashEntries = true,
  }) async {
    final uid = currentUid();
    final referencing = await (db.select(db.shipments)
          ..where((t) => t.ownerUid.equals(uid) & t.marketId.equals(marketId))
          ..limit(1))
        .getSingleOrNull();
    if (referencing != null) {
      throw const MarketInUseError();
    }
    if (deleteCashEntries) {
      await (db.delete(db.cashEntries)
            ..where((t) =>
                t.ownerUid.equals(uid) & t.marketId.equals(marketId)))
          .go();
    }
    await (db.delete(db.markets)..where((t) => t.id.equals(marketId))).go();
  }

  @override
  Future<int> allocateCashSerial(String marketId) {
    return db.transaction(() async {
      final row = await (db.select(db.markets)
            ..where((t) => t.id.equals(marketId)))
          .getSingleOrNull();
      if (row == null) {
        throw const MarketNotFoundError();
      }
      final next = row.cashSerialNext;
      final now = DateTime.now().millisecondsSinceEpoch;
      await (db.update(db.markets)..where((t) => t.id.equals(marketId))).write(
        MarketsCompanion(
          cashSerialNext: Value(next + 1),
          updatedAt: Value(now),
        ),
      );
      return next;
    });
  }
}
