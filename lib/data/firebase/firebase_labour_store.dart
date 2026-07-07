import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/error/app_error.dart';
import '../../domain/entities/labour_job.dart';
import '../../domain/record_status.dart';
import '../../domain/repositories/labour_store.dart';
import '../../domain/repositories/serial_meta_store.dart';
import 'firebase_serial_meta_store.dart';
import 'mappers/firestore_mappers.dart';

/// Firebase [LabourStore]: `users/{uid}/labourJobs`, ordered by start date
/// desc, with serial allocation on create and a completed-record write guard.
class FirebaseLabourStore implements LabourStore {
  FirebaseLabourStore({
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
      _firestore.collection('users').doc(_uid).collection('labourJobs');

  @override
  Stream<List<LabourJob>> watchLabourJobs() {
    return _col.orderBy('dateStart', descending: true).snapshots().map(
          (s) => s.docs.map(labourFromDoc).toList(),
        );
  }

  @override
  Future<void> refreshFromServer() async {
    await _col
        .orderBy('dateStart', descending: true)
        .get(const GetOptions(source: Source.server));
  }

  @override
  Future<String> createLabourJob({
    required DateTime dateStart,
    required DateTime dateEnd,
    required double totalCost,
    required double receivedPayment,
    required String remarks,
  }) async {
    final serial = await _serialMeta.allocateLabourSerial();
    final doc = _col.doc();
    final job = LabourJob(
      id: doc.id,
      serial: serial,
      dateStart: dateStart,
      dateEnd: dateEnd,
      totalCost: totalCost,
      receivedPayment: receivedPayment,
      remainingBalance: 0,
      status: RecordStatuses.pending,
      remarks: remarks,
      createdAt: null,
      updatedAt: null,
    );
    await doc.set(labourToFirestoreCreate(job));
    return doc.id;
  }

  @override
  Future<void> updateLabourJob(LabourJob job) {
    return _guardedWrite(
      job.id,
      () => _col.doc(job.id).update(labourToFirestoreWrite(job)),
    );
  }

  @override
  Future<void> deleteLabourJob(String id) =>
      _guardedWrite(id, () => _col.doc(id).delete());

  Future<void> _guardedWrite(String id, Future<void> Function() op) async {
    final snap = await _col.doc(id).get();
    final data = snap.data() ?? {};
    final status = (data['status'] as String?) ?? RecordStatuses.pending;
    if (status == RecordStatuses.completed) {
      throw const RecordLockedError();
    }
    await op();
  }
}
