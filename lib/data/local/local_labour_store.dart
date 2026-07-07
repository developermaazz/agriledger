import 'package:drift/drift.dart';

import '../../core/error/app_error.dart';
import '../../domain/entities/labour_job.dart';
import '../../domain/record_status.dart';
import '../../domain/repositories/labour_store.dart';
import '../../domain/repositories/serial_meta_store.dart';
import 'db/app_database.dart';
import 'local_ids.dart';
import 'mappers/local_mappers.dart';

/// Local [LabourStore]. Scoped by `ownerUid`, ordered by start date desc, with
/// serial allocation on create and a completed-record write guard.
class LocalLabourStore implements LabourStore {
  LocalLabourStore({
    required this.db,
    required this.currentUid,
    required this.serialMeta,
  });

  final AppDatabase db;
  final String Function() currentUid;
  final SerialMetaStore serialMeta;

  @override
  Stream<List<LabourJob>> watchLabourJobs() {
    final uid = currentUid();
    return (db.select(db.labourJobs)
          ..where((t) => t.ownerUid.equals(uid))
          ..orderBy([(t) => OrderingTerm.desc(t.dateStart)]))
        .watch()
        .map((rows) => rows.map(labourFromRow).toList());
  }

  @override
  Future<void> refreshFromServer() async {}

  @override
  Future<String> createLabourJob({
    required DateTime dateStart,
    required DateTime dateEnd,
    required double totalCost,
    required double receivedPayment,
    required String remarks,
  }) async {
    final uid = currentUid();
    final serial = await serialMeta.allocateLabourSerial();
    final id = newLocalId();
    final now = DateTime.now().millisecondsSinceEpoch;
    final d = LabourJob.derivedFields(
      totalCost: totalCost,
      receivedPayment: receivedPayment,
    );
    await db.into(db.labourJobs).insert(
          LabourJobsCompanion.insert(
            id: id,
            ownerUid: uid,
            serial: serial,
            dateStart: dateStart.millisecondsSinceEpoch,
            dateEnd: dateEnd.millisecondsSinceEpoch,
            totalCost: totalCost,
            receivedPayment: receivedPayment,
            remainingBalance: d['remainingBalance'] as double,
            status: d['status'] as String,
            remarks: remarks,
            createdAt: Value(now),
            updatedAt: Value(now),
          ),
        );
    return id;
  }

  @override
  Future<void> updateLabourJob(LabourJob job) async {
    await _guardedWrite(job.id, () async {
      final now = DateTime.now().millisecondsSinceEpoch;
      final d = LabourJob.derivedFields(
        totalCost: job.totalCost,
        receivedPayment: job.receivedPayment,
      );
      await (db.update(db.labourJobs)..where((t) => t.id.equals(job.id))).write(
        LabourJobsCompanion(
          dateStart: Value(job.dateStart.millisecondsSinceEpoch),
          dateEnd: Value(job.dateEnd.millisecondsSinceEpoch),
          totalCost: Value(job.totalCost),
          receivedPayment: Value(job.receivedPayment),
          remainingBalance: Value(d['remainingBalance'] as double),
          status: Value(d['status'] as String),
          remarks: Value(job.remarks),
          updatedAt: Value(now),
        ),
      );
    });
  }

  @override
  Future<void> deleteLabourJob(String id) {
    return _guardedWrite(
      id,
      () => (db.delete(db.labourJobs)..where((t) => t.id.equals(id))).go(),
    );
  }

  Future<void> _guardedWrite(String id, Future<void> Function() op) async {
    final row = await (db.select(db.labourJobs)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    final status = row?.status ?? RecordStatuses.pending;
    if (status == RecordStatuses.completed) {
      throw const RecordLockedError();
    }
    await op();
  }
}
