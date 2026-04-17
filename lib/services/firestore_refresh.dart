import 'labour_repository.dart';
import 'market_cash_repository.dart';
import 'market_repository.dart';
import 'shipment_repository.dart';

/// Pull-to-refresh: forces Firestore server reads so streams and totals update.
Future<void> refreshAllUserDataFromServer({
  required ShipmentRepository shipmentRepository,
  required LabourRepository labourRepository,
  required MarketRepository marketRepository,
  required MarketCashRepository marketCashRepository,
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
