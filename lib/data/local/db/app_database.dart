import 'package:drift/drift.dart';

part 'app_database.g.dart';

// All user data is scoped by [ownerUid] to mirror the Firebase `users/{uid}/…`
// partitioning (anonymous and email accounts get separate data). Dates are
// stored as epoch milliseconds.

/// On-device accounts for local auth (email/password + anonymous).
@DataClassName('AccountRow')
class Accounts extends Table {
  TextColumn get uid => text()();
  TextColumn get email => text().nullable()();
  TextColumn get passwordHash => text().nullable()();
  TextColumn get salt => text().nullable()();
  BoolColumn get isAnonymous => boolean().withDefault(const Constant(false))();
  IntColumn get createdAt => integer()();

  @override
  Set<Column<Object>> get primaryKey => {uid};
}

/// Single-row current-session holder (id is always 0).
@DataClassName('SessionRow')
class SessionRows extends Table {
  IntColumn get id => integer()();
  TextColumn get currentUid => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Per-uid shipment/labour serial counters (post-increment, default 1).
@DataClassName('SerialCounterRow')
class SerialCounters extends Table {
  TextColumn get uid => text()();
  IntColumn get shipmentNext => integer().withDefault(const Constant(1))();
  IntColumn get labourNext => integer().withDefault(const Constant(1))();

  @override
  Set<Column<Object>> get primaryKey => {uid};
}

@DataClassName('MarketRow')
class Markets extends Table {
  TextColumn get id => text()();
  TextColumn get ownerUid => text()();
  TextColumn get name => text()();
  IntColumn get cashSerialNext => integer().withDefault(const Constant(1))();
  IntColumn get createdAt => integer().nullable()();
  IntColumn get updatedAt => integer().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('ShipmentRow')
class Shipments extends Table {
  TextColumn get id => text()();
  TextColumn get ownerUid => text()();
  IntColumn get serial => integer()();
  IntColumn get date => integer()();
  TextColumn get marketId => text()();
  TextColumn get marketName => text()();
  TextColumn get buyerName => text()();
  RealColumn get quantity => real()();
  RealColumn get totalAmount => real()();
  RealColumn get amountReceived => real()();
  RealColumn get balance => real()();
  TextColumn get status => text()();
  TextColumn get remarks => text()();
  IntColumn get createdAt => integer().nullable()();
  IntColumn get updatedAt => integer().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('CashEntryRow')
class CashEntries extends Table {
  TextColumn get id => text()();
  TextColumn get ownerUid => text()();
  TextColumn get marketId => text()();
  IntColumn get serial => integer()();
  IntColumn get date => integer()();
  RealColumn get amountReceived => real()();
  RealColumn get payments => real()();
  RealColumn get previousCash => real()();
  RealColumn get cashAvailable => real()();
  RealColumn get balance => real()();
  TextColumn get remarks => text()();
  IntColumn get createdAt => integer().nullable()();
  IntColumn get updatedAt => integer().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('LabourJobRow')
class LabourJobs extends Table {
  TextColumn get id => text()();
  TextColumn get ownerUid => text()();
  IntColumn get serial => integer()();
  IntColumn get dateStart => integer()();
  IntColumn get dateEnd => integer()();
  RealColumn get totalCost => real()();
  RealColumn get receivedPayment => real()();
  RealColumn get remainingBalance => real()();
  TextColumn get status => text()();
  TextColumn get remarks => text()();
  IntColumn get createdAt => integer().nullable()();
  IntColumn get updatedAt => integer().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DriftDatabase(
  tables: [
    Accounts,
    SessionRows,
    SerialCounters,
    Markets,
    Shipments,
    CashEntries,
    LabourJobs,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 1;
}
