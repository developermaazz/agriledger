import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/market.dart';

class MarketRepository {
  MarketRepository({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  String get _uid {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      throw StateError('Not signed in');
    }
    return uid;
  }

  CollectionReference<Map<String, dynamic>> get _marketsCol =>
      _firestore.collection('users').doc(_uid).collection('markets');

  Stream<List<Market>> watchMarkets() {
    return _marketsCol.orderBy('name').snapshots().map(
          (s) => s.docs.map(Market.fromFirestore).toList(),
        );
  }

  Future<String> createMarket(String name) async {
    final doc = _marketsCol.doc();
    final market = Market(
      id: doc.id,
      name: name.trim(),
      cashSerialNext: 1,
      createdAt: null,
      updatedAt: null,
    );
    await doc.set(market.toFirestoreCreate());
    return doc.id;
  }

  Future<void> updateMarketName(String id, String name) {
    return _marketsCol.doc(id).update({
      'name': name.trim(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Allocates next cash entry serial for this market (transaction).
  Future<int> allocateCashSerial(String marketId) async {
    final ref = _marketsCol.doc(marketId);
    return _firestore.runTransaction((tx) async {
      final snap = await tx.get(ref);
      if (!snap.exists) {
        throw StateError('Market not found');
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
