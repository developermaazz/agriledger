import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/error/app_error.dart';
import '../../domain/entities/market.dart';
import '../../domain/repositories/market_store.dart';
import 'mappers/firestore_mappers.dart';

/// Firebase [MarketStore]: `users/{uid}/markets`, ordered by name asc, with
/// per-market cash-serial allocation and referential-integrity-checked delete.
class FirebaseMarketStore implements MarketStore {
  FirebaseMarketStore({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  String get _uid {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      throw const NotSignedInError();
    }
    return uid;
  }

  CollectionReference<Map<String, dynamic>> get _marketsCol =>
      _firestore.collection('users').doc(_uid).collection('markets');

  @override
  Stream<List<Market>> watchMarkets() {
    return _marketsCol.orderBy('name').snapshots().map(
          (s) => s.docs.map(marketFromDoc).toList(),
        );
  }

  @override
  Future<void> refreshFromServer() async {
    await _marketsCol
        .orderBy('name')
        .get(const GetOptions(source: Source.server));
  }

  @override
  Future<String> createMarket(String name) async {
    final doc = _marketsCol.doc();
    final market = Market(
      id: doc.id,
      name: name.trim(),
      cashSerialNext: 1,
      createdAt: null,
      updatedAt: null,
    );
    await doc.set(marketToFirestoreCreate(market));
    return doc.id;
  }

  @override
  Future<void> updateMarketName(String id, String name) {
    return _marketsCol.doc(id).update({
      'name': name.trim(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> deleteMarket(
    String marketId, {
    bool deleteCashEntries = true,
  }) async {
    final isUsed = await _isMarketReferencedByAnyShipment(marketId);
    if (isUsed) {
      throw const MarketInUseError();
    }

    if (deleteCashEntries) {
      await _deleteMarketCashEntries(marketId);
    }
    await _marketsCol.doc(marketId).delete();
  }

  Future<bool> _isMarketReferencedByAnyShipment(String marketId) async {
    final snap = await _firestore
        .collection('users')
        .doc(_uid)
        .collection('shipments')
        .where('marketId', isEqualTo: marketId)
        .limit(1)
        .get();
    return snap.docs.isNotEmpty;
  }

  Future<void> _deleteMarketCashEntries(String marketId) async {
    final col = _marketsCol.doc(marketId).collection('cashEntries');
    while (true) {
      final snap = await col.limit(400).get();
      if (snap.docs.isEmpty) {
        return;
      }
      final batch = _firestore.batch();
      for (final d in snap.docs) {
        batch.delete(d.reference);
      }
      await batch.commit();
    }
  }

  @override
  Future<int> allocateCashSerial(String marketId) async {
    final ref = _marketsCol.doc(marketId);
    return _firestore.runTransaction((tx) async {
      final snap = await tx.get(ref);
      if (!snap.exists) {
        throw const MarketNotFoundError();
      }
      final data = snap.data() ?? {};
      final next = (data['cashSerialNext'] as int?) ?? 1;
      tx.update(ref, {
        'cashSerialNext': next + 1,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return next;
    });
  }
}
