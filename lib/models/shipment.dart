import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/record_status.dart';

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

  factory Shipment.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return Shipment(
      id: doc.id,
      serial: (data['serial'] as int?) ?? 0,
      date: ((data['date'] as Timestamp?) ?? Timestamp.now()).toDate(),
      marketId: (data['marketId'] as String?) ?? '',
      marketName: (data['marketName'] as String?) ?? '',
      buyerName: (data['buyerName'] as String?) ?? '',
      quantity: ((data['quantity'] as num?) ?? 0).toDouble(),
      totalAmount: ((data['totalAmount'] as num?) ?? 0).toDouble(),
      amountReceived: ((data['amountReceived'] as num?) ?? 0).toDouble(),
      balance: ((data['balance'] as num?) ?? 0).toDouble(),
      status: (data['status'] as String?) ?? RecordStatuses.pending,
      remarks: (data['remarks'] as String?) ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

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

  Map<String, dynamic> toFirestoreWrite() {
    final d = derivedFields(
      totalAmount: totalAmount,
      amountReceived: amountReceived,
    );
    return {
      'serial': serial,
      'date': Timestamp.fromDate(date),
      'marketId': marketId,
      'marketName': marketName,
      'buyerName': buyerName,
      'quantity': quantity,
      'totalAmount': totalAmount,
      'amountReceived': amountReceived,
      'balance': d['balance'],
      'status': d['status'],
      'remarks': remarks,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  Map<String, dynamic> toFirestoreCreate() {
    return {
      ...toFirestoreWrite(),
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
