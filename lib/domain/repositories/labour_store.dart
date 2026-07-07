import '../entities/labour_job.dart';

/// Backend-agnostic labour-job data contract.
///
/// Reactive reads are ordered by start date descending. `createLabourJob`
/// allocates a serial before writing. `updateLabourJob`/`deleteLabourJob`
/// raise `RecordLockedError` when the record's status is `completed`.
abstract interface class LabourStore {
  Stream<List<LabourJob>> watchLabourJobs();

  Future<void> refreshFromServer();

  Future<String> createLabourJob({
    required DateTime dateStart,
    required DateTime dateEnd,
    required double totalCost,
    required double receivedPayment,
    required String remarks,
  });

  Future<void> updateLabourJob(LabourJob job);

  Future<void> deleteLabourJob(String id);
}
