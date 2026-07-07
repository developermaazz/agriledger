/// Shared helpers for backend-neutral entity JSON serialization.
///
/// Entities serialize dates as epoch milliseconds so the representation is
/// independent of any backend (Firestore `Timestamp`, sqlite ints, …). The
/// Firebase adapter maps to/from `Timestamp` separately in its own mappers.
library;

DateTime? dateFromMillis(Object? value) =>
    value is int ? DateTime.fromMillisecondsSinceEpoch(value) : null;

int? millisFromDate(DateTime? date) => date?.millisecondsSinceEpoch;
