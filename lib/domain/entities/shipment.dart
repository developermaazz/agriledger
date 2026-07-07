import '../record_status.dart';
import 'entity_json.dart';

/// A shipment record. Backend-neutral: no Firestore/SQL types. Balance and
/// status are derived from the amounts via [derivedFields] at write time.
class Shipment {
  const Shipment({
    required this.id,
    required this.serial,
    required this.date,
    required this.marketId,
    required this.marketName,
    required this.buyerName,
    required this.quantity,
    required this.totalAmount,
    required this.amountReceived,
    required this.balance,
    required this.status,
    required this.remarks,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final int serial;
  final DateTime date;
  final String marketId;
  final String marketName;
  final String buyerName;
  final double quantity;
  final double totalAmount;
  final double amountReceived;
  final double balance;
  final String status;
  final String remarks;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  /// The balance/status business rule: `balance = total - received`, and the
  /// status is derived from the balance. Both backends call this so the rule
  /// has a single definition.
  static Map<String, dynamic> derivedFields({
    required double totalAmount,
    required double amountReceived,
  }) {
    final balance = totalAmount - amountReceived;
    return {
      'balance': balance,
      'status': statusFromBalance(balance),
    };
  }

  /// Backend-neutral serialization (dates as epoch millis). Used by the local
  /// backend and by migration/export.
  Map<String, dynamic> toJson() => {
        'id': id,
        'serial': serial,
        'date': date.millisecondsSinceEpoch,
        'marketId': marketId,
        'marketName': marketName,
        'buyerName': buyerName,
        'quantity': quantity,
        'totalAmount': totalAmount,
        'amountReceived': amountReceived,
        'balance': balance,
        'status': status,
        'remarks': remarks,
        'createdAt': millisFromDate(createdAt),
        'updatedAt': millisFromDate(updatedAt),
      };

  factory Shipment.fromJson(Map<String, dynamic> json) => Shipment(
        id: (json['id'] as String?) ?? '',
        serial: (json['serial'] as int?) ?? 0,
        date: dateFromMillis(json['date']) ?? DateTime.now(),
        marketId: (json['marketId'] as String?) ?? '',
        marketName: (json['marketName'] as String?) ?? '',
        buyerName: (json['buyerName'] as String?) ?? '',
        quantity: ((json['quantity'] as num?) ?? 0).toDouble(),
        totalAmount: ((json['totalAmount'] as num?) ?? 0).toDouble(),
        amountReceived: ((json['amountReceived'] as num?) ?? 0).toDouble(),
        balance: ((json['balance'] as num?) ?? 0).toDouble(),
        status: (json['status'] as String?) ?? RecordStatuses.pending,
        remarks: (json['remarks'] as String?) ?? '',
        createdAt: dateFromMillis(json['createdAt']),
        updatedAt: dateFromMillis(json['updatedAt']),
      );
}
