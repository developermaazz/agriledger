import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../domain/cash_ledger_math.dart';
import '../models/cash_entry.dart';
import 'market_repository.dart';

class MarketCashRepository {
  MarketCashRepository({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
    MarketRepository? marketRepository,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance,
        _marketRepository = marketRepository ??
            MarketRepository(firestore: firestore, auth: auth);

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final MarketRepository _marketRepository;

  String get _uid {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      throw StateError('Not signed in');
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

  Stream<List<CashEntry>> watchCashEntries(String marketId) {
    return _cashCol(marketId)
        .orderBy('date')
        .orderBy('serial')
        .snapshots()
        .map((s) => s.docs.map(CashEntry.fromFirestore).toList());
  }

  Future<List<CashEntry>> fetchCashEntriesOnce(String marketId) async {
    final snap =
        await _cashCol(marketId).orderBy('date').orderBy('serial').get();
    return snap.docs.map(CashEntry.fromFirestore).toList();
  }

  Future<String> createCashEntry({
    required String marketId,
    required DateTime date,
    required double amountReceived,
    required double payments,
    required String remarks,
  }) async {
    final serial = await _marketRepository.allocateCashSerial(marketId);
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
    await doc.set(entry.toFirestoreCreate());
    await recomputeChain(marketId);
    return doc.id;
  }

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

  Future<void> deleteCashEntry(String marketId, String entryId) async {
    await _cashCol(marketId).doc(entryId).delete();
    await recomputeChain(marketId);
  }

  /// Recompute [previousCash], [cashAvailable], [balance] for all rows in order.
  Future<void> recomputeChain(String marketId) async {
    final snap = await _cashCol(marketId).orderBy('date').orderBy('serial').get();
    final entries = snap.docs.map(CashEntry.fromFirestore).toList();
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
  }

  /// Latest end-of-row cash ([balance]) for this market, or 0 if no entries.
  Future<double> latestBalanceForMarket(String marketId) async {
    final snap = await _cashCol(marketId).orderBy('date', descending: true).orderBy('serial', descending: true).limit(1).get();
    if (snap.docs.isEmpty) {
      return 0;
    }
    return CashEntry.fromFirestore(snap.docs.first).balance;
  }
}
