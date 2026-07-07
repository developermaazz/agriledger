import 'package:drift/drift.dart';

import '../../core/error/app_error.dart';
import '../../domain/entities/shipment.dart';
import '../../domain/record_status.dart';
import '../../domain/repositories/serial_meta_store.dart';
import '../../domain/repositories/shipment_store.dart';
import 'db/app_database.dart';
import 'local_ids.dart';
import 'mappers/local_mappers.dart';

/// Local [ShipmentStore]. Scoped by `ownerUid`, ordered by date desc, with
/// serial allocation on create and a completed-record write guard.
class LocalShipmentStore implements ShipmentStore {
  LocalShipmentStore({
    required this.db,
    required this.currentUid,
    required this.serialMeta,
  });

  final AppDatabase db;
  final String Function() currentUid;
  final SerialMetaStore serialMeta;

  @override
  Stream<List<Shipment>> watchShipments() {
    final uid = currentUid();
    return (db.select(db.shipments)
          ..where((t) => t.ownerUid.equals(uid))
          ..orderBy([(t) => OrderingTerm.desc(t.date)]))
        .watch()
        .map((rows) => rows.map(shipmentFromRow).toList());
  }

  @override
  Future<void> refreshFromServer() async {}

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
    final uid = currentUid();
    final serial = await serialMeta.allocateShipmentSerial();
    final id = newLocalId();
    final now = DateTime.now().millisecondsSinceEpoch;
    final d = Shipment.derivedFields(
      totalAmount: totalAmount,
      amountReceived: amountReceived,
    );
    await db.into(db.shipments).insert(
          ShipmentsCompanion.insert(
            id: id,
            ownerUid: uid,
            serial: serial,
            date: date.millisecondsSinceEpoch,
            marketId: marketId,
            marketName: marketName,
            buyerName: buyerName,
            quantity: quantity,
            totalAmount: totalAmount,
            amountReceived: amountReceived,
            balance: d['balance'] as double,
            status: d['status'] as String,
            remarks: remarks,
            createdAt: Value(now),
            updatedAt: Value(now),
          ),
        );
    return id;
  }

  @override
  Future<void> updateShipment(Shipment shipment) async {
    await _guardedWrite(shipment.id, () async {
      final now = DateTime.now().millisecondsSinceEpoch;
      final d = Shipment.derivedFields(
        totalAmount: shipment.totalAmount,
        amountReceived: shipment.amountReceived,
      );
      await (db.update(db.shipments)..where((t) => t.id.equals(shipment.id)))
          .write(
        ShipmentsCompanion(
          date: Value(shipment.date.millisecondsSinceEpoch),
          marketId: Value(shipment.marketId),
          marketName: Value(shipment.marketName),
          buyerName: Value(shipment.buyerName),
          quantity: Value(shipment.quantity),
          totalAmount: Value(shipment.totalAmount),
          amountReceived: Value(shipment.amountReceived),
          balance: Value(d['balance'] as double),
          status: Value(d['status'] as String),
          remarks: Value(shipment.remarks),
          updatedAt: Value(now),
        ),
      );
    });
  }

  @override
  Future<void> deleteShipment(String id) {
    return _guardedWrite(
      id,
      () => (db.delete(db.shipments)..where((t) => t.id.equals(id))).go(),
    );
  }

  Future<void> _guardedWrite(String id, Future<void> Function() op) async {
    final row = await (db.select(db.shipments)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    final status = row?.status ?? RecordStatuses.pending;
    if (status == RecordStatuses.completed) {
      throw const RecordLockedError();
    }
    await op();
  }
}
