import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// `users/{uid}/meta/serialCounters` — shipment and labour serials.
class SerialMetaRepository {
  SerialMetaRepository({
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

  DocumentReference<Map<String, dynamic>> get _countersRef =>
      _firestore.collection('users').doc(_uid).collection('meta').doc('serialCounters');

  /// Returns next shipment serial and increments counter.
  Future<int> allocateShipmentSerial() async {
    return _firestore.runTransaction((tx) async {
      final snap = await tx.get(_countersRef);
      final data = snap.data() ?? {};
      final next = (data['shipmentNext'] as int?) ?? 1;
      final labourNext = (data['labourNext'] as int?) ?? 1;
      tx.set(_countersRef, {
        'shipmentNext': next + 1,
        'labourNext': labourNext,
      }, SetOptions(merge: true));
      return next;
    });
  }

  /// Returns next labour serial and increments counter.
  Future<int> allocateLabourSerial() async {
    return _firestore.runTransaction((tx) async {
      final snap = await tx.get(_countersRef);
      final data = snap.data() ?? {};
      final shipmentNext = (data['shipmentNext'] as int?) ?? 1;
      final next = (data['labourNext'] as int?) ?? 1;
      tx.set(_countersRef, {
        'shipmentNext': shipmentNext,
        'labourNext': next + 1,
      }, SetOptions(merge: true));
      return next;
    });
  }
}
