import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/error/app_error.dart';
import '../../domain/entities/shipment.dart';
import '../../domain/record_status.dart';
import '../../domain/repositories/serial_meta_store.dart';
import '../../domain/repositories/shipment_store.dart';
import 'firebase_serial_meta_store.dart';
import 'mappers/firestore_mappers.dart';

/// Firebase [ShipmentStore]: `users/{uid}/shipments`, ordered by date desc,
/// with serial allocation on create and a completed-record write guard.
class FirebaseShipmentStore implements ShipmentStore {
  FirebaseShipmentStore({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
    SerialMetaStore? serialMeta,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance,
        _serialMeta = serialMeta ??
            FirebaseSerialMetaStore(firestore: firestore, auth: auth);

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final SerialMetaStore _serialMeta;

  String get _uid {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      throw const NotSignedInError();
    }
    return uid;
  }

  CollectionReference<Map<String, dynamic>> get _col =>
      _firestore.collection('users').doc(_uid).collection('shipments');

  @override
  Stream<List<Shipment>> watchShipments() {
    return _col.orderBy('date', descending: true).snapshots().map(
          (s) => s.docs.map(shipmentFromDoc).toList(),
        );
  }

  @override
  Future<void> refreshFromServer() async {
    await _col
        .orderBy('date', descending: true)
        .get(const GetOptions(source: Source.server));
  }

  @override
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
    await doc.set(shipmentToFirestoreCreate(shipment));
    return doc.id;
  }

  @override
  Future<void> updateShipment(Shipment shipment) {
    return _guardedWrite(
      shipment.id,
      () => _col.doc(shipment.id).update(shipmentToFirestoreWrite(shipment)),
    );
  }

  @override
  Future<void> deleteShipment(String id) {
    return _guardedWrite(id, () => _col.doc(id).delete());
  }

  Future<void> _guardedWrite(String shipmentId, Future<void> Function() op) async {
    final snap = await _col.doc(shipmentId).get();
    final data = snap.data() ?? {};
    final status = (data['status'] as String?) ?? RecordStatuses.pending;
    if (status == RecordStatuses.completed) {
      throw const RecordLockedError();
    }
    await op();
  }
}
