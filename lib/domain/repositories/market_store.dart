import '../entities/market.dart';

/// Backend-agnostic market data contract.
///
/// Reactive reads are ordered by name ascending. `deleteMarket` raises
/// `MarketInUseError` when any shipment references the market, and optionally
/// cascades the market's cash entries. `allocateCashSerial` atomically returns
/// the next per-market cash serial.
abstract interface class MarketStore {
  Stream<List<Market>> watchMarkets();

  Future<void> refreshFromServer();

  Future<String> createMarket(String name);

  Future<void> updateMarketName(String id, String name);

  Future<void> deleteMarket(String marketId, {bool deleteCashEntries = true});

  Future<int> allocateCashSerial(String marketId);
}
