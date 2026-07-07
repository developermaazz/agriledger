import 'package:drift/drift.dart';

import '../../domain/repositories/serial_meta_store.dart';
import 'db/app_database.dart';

/// Local [SerialMetaStore]. Per-uid counters in the `serial_counters` table,
/// allocated atomically inside a drift transaction (post-increment, default 1).
class LocalSerialMetaStore implements SerialMetaStore {
  LocalSerialMetaStore({required this.db, required this.currentUid});

  final AppDatabase db;
  final String Function() currentUid;

  Future<int> _allocate({required bool shipment}) {
    final uid = currentUid();
    return db.transaction(() async {
      final row = await (db.select(db.serialCounters)
            ..where((t) => t.uid.equals(uid)))
          .getSingleOrNull();
      final shipmentNext = row?.shipmentNext ?? 1;
      final labourNext = row?.labourNext ?? 1;
      final next = shipment ? shipmentNext : labourNext;
      await db.into(db.serialCounters).insertOnConflictUpdate(
            SerialCountersCompanion.insert(
              uid: uid,
              shipmentNext: Value(shipment ? shipmentNext + 1 : shipmentNext),
              labourNext: Value(shipment ? labourNext : labourNext + 1),
            ),
          );
      return next;
    });
  }

  @override
  Future<int> allocateShipmentSerial() => _allocate(shipment: true);

  @override
  Future<int> allocateLabourSerial() => _allocate(shipment: false);
}
