import '../../../domain/repositories/labour_store.dart';
import '../../../domain/repositories/market_cash_store.dart';
import '../../../domain/repositories/market_store.dart';
import '../../../domain/repositories/shipment_store.dart';

/// Seeds a fresh account with sample data so the app is immediately usable
/// offline. Goes through the stores so serials, derived balances, and the cash
/// running-balance chain are computed exactly as for real user input.
Future<void> seedSampleData({
  required MarketStore markets,
  required ShipmentStore shipments,
  required LabourStore labour,
  required MarketCashStore cash,
}) async {
  final now = DateTime.now();
  DateTime daysAgo(int d) => now.subtract(Duration(days: d));

  final m1 = await markets.createMarket('Downtown Market');
  final m2 = await markets.createMarket('Riverside Market');

  await shipments.createShipment(
    date: daysAgo(2),
    marketId: m1,
    marketName: 'Downtown Market',
    buyerName: 'Ali Traders',
    quantity: 120,
    totalAmount: 45000,
    amountReceived: 30000,
    remarks: 'Apples — 12 crates',
  );
  await shipments.createShipment(
    date: daysAgo(5),
    marketId: m2,
    marketName: 'Riverside Market',
    buyerName: 'Green Grocers',
    quantity: 80,
    totalAmount: 26000,
    amountReceived: 26000, // completed
    remarks: 'Oranges',
  );
  await shipments.createShipment(
    date: daysAgo(1),
    marketId: m1,
    marketName: 'Downtown Market',
    buyerName: 'Fresh Mart',
    quantity: 200,
    totalAmount: 60000,
    amountReceived: 20000,
    remarks: 'Bananas',
  );

  await labour.createLabourJob(
    dateStart: daysAgo(6),
    dateEnd: daysAgo(5),
    totalCost: 8000,
    receivedPayment: 8000, // completed
    remarks: 'Loading & unloading',
  );
  await labour.createLabourJob(
    dateStart: daysAgo(3),
    dateEnd: daysAgo(2),
    totalCost: 12000,
    receivedPayment: 5000,
    remarks: 'Sorting crew',
  );

  await cash.createCashEntry(
    marketId: m1,
    date: daysAgo(4),
    amountReceived: 30000,
    payments: 5000,
    remarks: 'Opening float',
  );
  await cash.createCashEntry(
    marketId: m1,
    date: daysAgo(2),
    amountReceived: 20000,
    payments: 12000,
    remarks: 'Buyer payment / labour',
  );
  await cash.createCashEntry(
    marketId: m2,
    date: daysAgo(3),
    amountReceived: 26000,
    payments: 8000,
    remarks: 'Sales & expenses',
  );
}
