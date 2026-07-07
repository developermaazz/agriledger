/// Backend-agnostic serial allocator for shipments and labour jobs.
///
/// Both counters are 1-based and monotonically increasing; each allocation is
/// atomic and returns the value to use (pre-increment). Cash serials are
/// allocated separately by `MarketStore.allocateCashSerial`.
abstract interface class SerialMetaStore {
  Future<int> allocateShipmentSerial();

  Future<int> allocateLabourSerial();
}
