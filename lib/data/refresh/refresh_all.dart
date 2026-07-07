import '../../domain/repositories/labour_store.dart';
import '../../domain/repositories/market_cash_store.dart';
import '../../domain/repositories/market_store.dart';
import '../../domain/repositories/shipment_store.dart';

/// Pull-to-refresh: asks each store for an authoritative refresh (a server read
/// on Firebase; a no-op on the local backend) so streams and totals update.
Future<void> refreshAllUserDataFromServer({
  required ShipmentStore shipmentRepository,
  required LabourStore labourRepository,
  required MarketStore marketRepository,
  required MarketCashStore marketCashRepository,
}) async {
  await Future.wait([
    shipmentRepository.refreshFromServer(),
    labourRepository.refreshFromServer(),
    marketRepository.refreshFromServer(),
  ]);
  final markets = await marketRepository.watchMarkets().first;
  if (markets.isEmpty) {
    return;
  }
  await Future.wait(
    markets.map((m) => marketCashRepository.refreshCashEntriesFromServer(m.id)),
  );
}
