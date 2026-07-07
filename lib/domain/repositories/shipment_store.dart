import '../entities/shipment.dart';

/// Backend-agnostic shipment data contract.
///
/// Reactive reads are ordered by date descending. `createShipment` allocates a
/// serial before writing. `updateShipment`/`deleteShipment` raise
/// `RecordLockedError` when the record's status is `completed`.
abstract interface class ShipmentStore {
  Stream<List<Shipment>> watchShipments();

  /// Forces an authoritative refresh (server read on Firebase; no-op on local).
  Future<void> refreshFromServer();

  Future<String> createShipment({
    required DateTime date,
    required String marketId,
    required String marketName,
    required String buyerName,
    required double quantity,
    required double totalAmount,
    required double amountReceived,
    required String remarks,
  });

  Future<void> updateShipment(Shipment shipment);

  Future<void> deleteShipment(String id);
}
