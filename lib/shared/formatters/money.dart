import 'package:intl/intl.dart';

/// Centralized money formatting.
///
/// Change [_currencySymbol] (or later wire it to Settings) to update the
/// currency prefix across the whole app.
class MoneyFmt {
  static String _currencySymbol = 'Rs';

  static String get currencySymbol => _currencySymbol;
  static set currencySymbol(String v) => _currencySymbol = v.trim().isEmpty ? 'Rs' : v.trim();

  static final NumberFormat _num = NumberFormat('#,##0.00');

  static String of(double amount) {
    return '$currencySymbol ${_num.format(amount)}';
  }
}

