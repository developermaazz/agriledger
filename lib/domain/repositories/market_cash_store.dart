import '../entities/cash_activity_line.dart';
import '../entities/cash_entry.dart';

/// Backend-agnostic per-market cash-ledger contract.
///
/// Reactive reads are ordered by date then serial (ascending) — the carry-
/// forward chain order. Every mutation re-runs [recomputeChain] so the
/// running-balance fields (`previousCash`/`cashAvailable`/`balance`) stay
/// consistent. Also exposes cross-market dashboard aggregations.
abstract interface class MarketCashStore {
  Stream<List<CashEntry>> watchCashEntries(String marketId);

  Future<void> refreshCashEntriesFromServer(String marketId);

  Future<List<CashEntry>> fetchCashEntriesOnce(String marketId);

  Future<String> createCashEntry({
    required String marketId,
    required DateTime date,
    required double amountReceived,
    required double payments,
    required String remarks,
  });

  /// Updates only the user-editable fields; derived running balances are
  /// recomputed by [recomputeChain].
  Future<void> updateCashEntryRaw({
    required String marketId,
    required String entryId,
    required DateTime date,
    required double amountReceived,
    required double payments,
    required String remarks,
  });

  Future<void> deleteCashEntry(String marketId, String entryId);

  /// Recomputes the running-balance chain for every row of the market.
  Future<void> recomputeChain(String marketId);

  /// End-of-chain balance for the market, or 0 when it has no entries.
  Future<double> latestBalanceForMarket(String marketId);

  /// Reactive sum of the latest per-market balances across all markets.
  Stream<double> watchDashboardTotalCash();

  /// Reactive newest cash rows across all markets (recent-activity feed).
  Stream<List<CashActivityLine>> watchCashActivityFeed();
}
