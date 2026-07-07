import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/error/app_error.dart';
import '../../domain/cash_ledger_math.dart';
import '../../domain/entities/cash_activity_line.dart';
import '../../domain/entities/cash_entry.dart';
import '../../domain/entities/market.dart';
import '../../domain/repositories/market_cash_store.dart';
import '../../domain/repositories/market_store.dart';
import 'firebase_market_store.dart';
import 'mappers/firestore_mappers.dart';

/// Firebase [MarketCashStore]: `users/{uid}/markets/{marketId}/cashEntries`,
/// ordered by date then serial, with running-balance recompute after every
/// mutation plus cross-market dashboard aggregations.
class FirebaseMarketCashStore implements MarketCashStore {
  FirebaseMarketCashStore({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
    MarketStore? marketStore,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance,
        _marketStore =
            marketStore ?? FirebaseMarketStore(firestore: firestore, auth: auth);

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final MarketStore _marketStore;

  String get _uid {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      throw const NotSignedInError();
    }
    return uid;
  }

  CollectionReference<Map<String, dynamic>> _cashCol(String marketId) {
    return _firestore
        .collection('users')
        .doc(_uid)
        .collection('markets')
        .doc(marketId)
        .collection('cashEntries');
  }

  @override
  Stream<List<CashEntry>> watchCashEntries(String marketId) {
    return _cashCol(marketId)
        .orderBy('date')
        .orderBy('serial')
        .snapshots()
        .map((s) => s.docs.map(cashEntryFromDoc).toList());
  }

  @override
  Future<void> refreshCashEntriesFromServer(String marketId) async {
    await _cashCol(marketId)
        .orderBy('date')
        .orderBy('serial')
        .get(const GetOptions(source: Source.server));
  }

  @override
  Future<List<CashEntry>> fetchCashEntriesOnce(String marketId) async {
    final snap =
        await _cashCol(marketId).orderBy('date').orderBy('serial').get();
    return snap.docs.map(cashEntryFromDoc).toList();
  }

  @override
  Future<String> createCashEntry({
    required String marketId,
    required DateTime date,
    required double amountReceived,
    required double payments,
    required String remarks,
  }) async {
    final serial = await _marketStore.allocateCashSerial(marketId);
    final doc = _cashCol(marketId).doc();
    final entry = CashEntry(
      id: doc.id,
      serial: serial,
      date: date,
      amountReceived: amountReceived,
      payments: payments,
      previousCash: 0,
      cashAvailable: 0,
      balance: 0,
      remarks: remarks,
      createdAt: null,
      updatedAt: null,
    );
    await doc.set(cashEntryToFirestoreCreate(entry));
    await recomputeChain(marketId);
    return doc.id;
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
    await _cashCol(marketId).doc(entryId).update({
      'date': Timestamp.fromDate(date),
      'amountReceived': amountReceived,
      'payments': payments,
      'remarks': remarks,
      'updatedAt': FieldValue.serverTimestamp(),
    });
    await recomputeChain(marketId);
  }

  @override
  Future<void> deleteCashEntry(String marketId, String entryId) async {
    await _cashCol(marketId).doc(entryId).delete();
    await recomputeChain(marketId);
  }

  @override
  Future<void> recomputeChain(String marketId) async {
    final snap =
        await _cashCol(marketId).orderBy('date').orderBy('serial').get();
    final entries = snap.docs.map(cashEntryFromDoc).toList();
    final computed = recomputeCashChain(entries);

    const chunk = 400;
    for (var i = 0; i < computed.length; i += chunk) {
      final batch = _firestore.batch();
      final end = (i + chunk < computed.length) ? i + chunk : computed.length;
      for (var j = i; j < end; j++) {
        final e = computed[j];
        final ref = _cashCol(marketId).doc(e.id);
        batch.update(ref, {
          'previousCash': e.previousCash,
          'cashAvailable': e.cashAvailable,
          'balance': e.balance,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
      await batch.commit();
    }

    await _firestore
        .collection('users')
        .doc(_uid)
        .collection('markets')
        .doc(marketId)
        .update({
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<double> latestBalanceForMarket(String marketId) async {
    final snap = await _cashCol(marketId)
        .orderBy('date', descending: true)
        .orderBy('serial', descending: true)
        .limit(1)
        .get();
    if (snap.docs.isEmpty) {
      return 0;
    }
    return cashEntryFromDoc(snap.docs.first).balance;
  }

  @override
  Stream<double> watchDashboardTotalCash() {
    return _marketStore.watchMarkets().asyncExpand((markets) {
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
    return _marketStore.watchMarkets().asyncExpand((markets) {
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
