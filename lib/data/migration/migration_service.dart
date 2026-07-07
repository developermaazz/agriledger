import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../domain/entities/cash_entry.dart';
import '../../domain/entities/labour_job.dart';
import '../../domain/entities/market.dart';
import '../../domain/entities/shipment.dart';
import '../../domain/repositories/labour_store.dart';
import '../../domain/repositories/market_cash_store.dart';
import '../../domain/repositories/market_store.dart';
import '../../domain/repositories/shipment_store.dart';

/// Counts of records imported, for user feedback.
class MigrationSummary {
  const MigrationSummary({
    required this.markets,
    required this.shipments,
    required this.labour,
    required this.cash,
  });

  final int markets;
  final int shipments;
  final int labour;
  final int cash;
}

/// Moves all user data between backends as backend-neutral JSON.
///
/// Import goes through the stores, so serials are re-allocated in original
/// order and the cash chain is recomputed — the data (amounts/dates/names) is
/// preserved and internally consistent, and it ADDS to the target (no wipe).
class MigrationService {
  const MigrationService({
    required this.markets,
    required this.shipments,
    required this.labour,
    required this.marketCash,
  });

  final MarketStore markets;
  final ShipmentStore shipments;
  final LabourStore labour;
  final MarketCashStore marketCash;

  static const int version = 1;

  /// Serializes every record to a JSON string.
  Future<String> exportToJson() async {
    final marketList = await markets.watchMarkets().first;
    final shipmentList = await shipments.watchShipments().first;
    final labourList = await labour.watchLabourJobs().first;

    final cash = <String, List<Map<String, dynamic>>>{};
    for (final m in marketList) {
      final entries = await marketCash.fetchCashEntriesOnce(m.id);
      cash[m.id] = entries.map((e) => e.toJson()).toList();
    }

    return const JsonEncoder.withIndent('  ').convert({
      'version': version,
      'markets': marketList.map((m) => m.toJson()).toList(),
      'shipments': shipmentList.map((s) => s.toJson()).toList(),
      'labour': labourList.map((l) => l.toJson()).toList(),
      'cash': cash,
    });
  }

  /// Exports data to a temp JSON file and opens the share sheet.
  Future<void> exportAndShare() async {
    final json = await exportToJson();
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/agri_ledger_export.json');
    await file.writeAsString(json);
    await SharePlus.instance.share(ShareParams(files: [XFile(file.path)]));
  }

  /// Imports JSON produced by [exportToJson] into the (current) stores.
  Future<MigrationSummary> importFromJson(String jsonStr) async {
    final data = jsonDecode(jsonStr) as Map<String, dynamic>;
    final idMap = <String, String>{}; // source marketId -> new marketId

    final marketList = (data['markets'] as List? ?? const [])
        .map((e) => Market.fromJson(e as Map<String, dynamic>))
        .toList();
    for (final m in marketList) {
      idMap[m.id] = await markets.createMarket(m.name);
    }

    final shipmentList = (data['shipments'] as List? ?? const [])
        .map((e) => Shipment.fromJson(e as Map<String, dynamic>))
        .toList()
      ..sort((a, b) => a.serial.compareTo(b.serial));
    for (final s in shipmentList) {
      await shipments.createShipment(
        date: s.date,
        marketId: idMap[s.marketId] ?? s.marketId,
        marketName: s.marketName,
        buyerName: s.buyerName,
        quantity: s.quantity,
        totalAmount: s.totalAmount,
        amountReceived: s.amountReceived,
        remarks: s.remarks,
      );
    }

    final labourList = (data['labour'] as List? ?? const [])
        .map((e) => LabourJob.fromJson(e as Map<String, dynamic>))
        .toList()
      ..sort((a, b) => a.serial.compareTo(b.serial));
    for (final j in labourList) {
      await labour.createLabourJob(
        dateStart: j.dateStart,
        dateEnd: j.dateEnd,
        totalCost: j.totalCost,
        receivedPayment: j.receivedPayment,
        remarks: j.remarks,
      );
    }

    var cashCount = 0;
    final cash = (data['cash'] as Map<String, dynamic>? ?? const {});
    for (final entry in cash.entries) {
      final targetMarketId = idMap[entry.key] ?? entry.key;
      final list = (entry.value as List)
          .map((e) => CashEntry.fromJson(e as Map<String, dynamic>))
          .toList()
        ..sort((a, b) => a.serial.compareTo(b.serial));
      for (final e in list) {
        await marketCash.createCashEntry(
          marketId: targetMarketId,
          date: e.date,
          amountReceived: e.amountReceived,
          payments: e.payments,
          remarks: e.remarks,
        );
        cashCount++;
      }
    }

    return MigrationSummary(
      markets: marketList.length,
      shipments: shipmentList.length,
      labour: labourList.length,
      cash: cashCount,
    );
  }
}
