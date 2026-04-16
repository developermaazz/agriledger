import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../domain/record_status.dart';
import '../models/shipment.dart';
import 'serial_meta_repository.dart';

class ShipmentRepository {
  ShipmentRepository({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
    SerialMetaRepository? serialMeta,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance,
        _serialMeta = serialMeta ?? SerialMetaRepository(firestore: firestore, auth: auth);

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final SerialMetaRepository _serialMeta;

  String get _uid {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      throw StateError('Not signed in');
    }
    return uid;
  }

  CollectionReference<Map<String, dynamic>> get _col =>
      _firestore.collection('users').doc(_uid).collection('shipments');

  Stream<List<Shipment>> watchShipments() {
    return _col.orderBy('date', descending: true).snapshots().map(
          (s) => s.docs.map(Shipment.fromFirestore).toList(),
        );
  }

  Future<String> createShipment({
    required DateTime date,
    required String marketId,
    required String marketName,
    required String buyerName,
    required double quantity,
    required double totalAmount,
    required double amountReceived,
    required String remarks,
  }) async {
    final serial = await _serialMeta.allocateShipmentSerial();
    final doc = _col.doc();
    final shipment = Shipment(
      id: doc.id,
      serial: serial,
      date: date,
      marketId: marketId,
      marketName: marketName,
      buyerName: buyerName,
      quantity: quantity,
      totalAmount: totalAmount,
      amountReceived: amountReceived,
      balance: 0,
      status: RecordStatuses.pending,
      remarks: remarks,
      createdAt: null,
      updatedAt: null,
    );
    await doc.set(shipment.toFirestoreCreate());
    return doc.id;
  }

  Future<void> updateShipment(Shipment s) {
    return _col.doc(s.id).update(s.toFirestoreWrite());
  }

  Future<void> deleteShipment(String id) {
    return _col.doc(id).delete();
  }
}
