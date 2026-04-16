/// Pending / completed / overpaid for shipments and labour.
abstract final class RecordStatuses {
  static const pending = 'pending';
  static const completed = 'completed';
  static const overpaid = 'overpaid';
}

String statusFromBalance(double balance) {
  if (balance > 0) {
    return RecordStatuses.pending;
  }
  if (balance == 0) {
    return RecordStatuses.completed;
  }
  return RecordStatuses.overpaid;
}
