import 'package:drift/drift.dart';

/// Fallback for platforms without a database implementation.
QueryExecutor openLocalDatabase() =>
    throw UnsupportedError('No local database implementation for this platform');
