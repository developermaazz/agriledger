import '../models/cash_entry.dart';

/// Recomputes running cash fields. Carry-forward uses end-of-row [balance]
/// as opening cash for the next row (spreadsheet-style).
List<CashEntry> recomputeCashChain(List<CashEntry> entries) {
  final sorted = List<CashEntry>.from(entries)
    ..sort((a, b) {
      final c = a.date.compareTo(b.date);
      if (c != 0) {
        return c;
      }
      return a.serial.compareTo(b.serial);
    });

  double opening = 0;
  final out = <CashEntry>[];
  for (final e in sorted) {
    final cashAvailable = opening + e.amountReceived;
    final balance = cashAvailable - e.payments;
    out.add(
      e.copyWith(
        previousCash: opening,
        cashAvailable: cashAvailable,
        balance: balance,
      ),
    );
    opening = balance;
  }
  return out;
}
