import 'cash_entry.dart';

/// One cash entry with its market label for dashboard / activity feeds.
class CashActivityLine {
  const CashActivityLine({required this.marketName, required this.entry});

  final String marketName;
  final CashEntry entry;
}
