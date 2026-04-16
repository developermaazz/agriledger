import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../domain/record_status.dart';
import '../models/labour_job.dart';
import 'serial_meta_repository.dart';

class LabourRepository {
  LabourRepository({
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
      _firestore.collection('users').doc(_uid).collection('labourJobs');

  Stream<List<LabourJob>> watchLabourJobs() {
    return _col.orderBy('dateStart', descending: true).snapshots().map(
          (s) => s.docs.map(LabourJob.fromFirestore).toList(),
        );
  }

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
    await doc.set(job.toFirestoreCreate());
    return doc.id;
  }

  Future<void> updateLabourJob(LabourJob job) {
    return _col.doc(job.id).update(job.toFirestoreWrite());
  }

  Future<void> deleteLabourJob(String id) => _col.doc(id).delete();
}
