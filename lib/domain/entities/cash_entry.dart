import 'entity_json.dart';

/// A cash-ledger entry. `previousCash`/`cashAvailable`/`balance` are the
/// running-balance chain fields, recomputed by the store after every mutation.
class CashEntry {
  const CashEntry({
    required this.id,
    required this.serial,
    required this.date,
    required this.amountReceived,
    required this.payments,
    required this.previousCash,
    required this.cashAvailable,
    required this.balance,
    required this.remarks,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final int serial;
  final DateTime date;
  final double amountReceived;
  final double payments;
  final double previousCash;
  final double cashAvailable;
  final double balance;
  final String remarks;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CashEntry copyWith({
    String? id,
    int? serial,
    DateTime? date,
    double? amountReceived,
    double? payments,
    double? previousCash,
    double? cashAvailable,
    double? balance,
    String? remarks,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CashEntry(
      id: id ?? this.id,
      serial: serial ?? this.serial,
      date: date ?? this.date,
      amountReceived: amountReceived ?? this.amountReceived,
      payments: payments ?? this.payments,
      previousCash: previousCash ?? this.previousCash,
      cashAvailable: cashAvailable ?? this.cashAvailable,
      balance: balance ?? this.balance,
      remarks: remarks ?? this.remarks,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'serial': serial,
        'date': date.millisecondsSinceEpoch,
        'amountReceived': amountReceived,
        'payments': payments,
        'previousCash': previousCash,
        'cashAvailable': cashAvailable,
        'balance': balance,
        'remarks': remarks,
        'createdAt': millisFromDate(createdAt),
        'updatedAt': millisFromDate(updatedAt),
      };

  factory CashEntry.fromJson(Map<String, dynamic> json) => CashEntry(
        id: (json['id'] as String?) ?? '',
        serial: (json['serial'] as int?) ?? 0,
        date: dateFromMillis(json['date']) ?? DateTime.now(),
        amountReceived: ((json['amountReceived'] as num?) ?? 0).toDouble(),
        payments: ((json['payments'] as num?) ?? 0).toDouble(),
        previousCash: ((json['previousCash'] as num?) ?? 0).toDouble(),
        cashAvailable: ((json['cashAvailable'] as num?) ?? 0).toDouble(),
        balance: ((json['balance'] as num?) ?? 0).toDouble(),
        remarks: (json['remarks'] as String?) ?? '',
        createdAt: dateFromMillis(json['createdAt']),
        updatedAt: dateFromMillis(json['updatedAt']),
      );
}
