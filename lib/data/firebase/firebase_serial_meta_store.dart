import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/error/app_error.dart';
import '../../domain/repositories/serial_meta_store.dart';

/// Firebase [SerialMetaStore]: `users/{uid}/meta/serialCounters` holds the
/// shipment and labour serial counters, allocated atomically via a transaction.
class FirebaseSerialMetaStore implements SerialMetaStore {
  FirebaseSerialMetaStore({
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

  DocumentReference<Map<String, dynamic>> get _countersRef => _firestore
      .collection('users')
      .doc(_uid)
      .collection('meta')
      .doc('serialCounters');

  @override
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

  @override
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
