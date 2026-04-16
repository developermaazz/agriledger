import 'package:cloud_firestore/cloud_firestore.dart';

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

  factory CashEntry.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return CashEntry(
      id: doc.id,
      serial: (data['serial'] as int?) ?? 0,
      date: ((data['date'] as Timestamp?) ?? Timestamp.now()).toDate(),
      amountReceived: ((data['amountReceived'] as num?) ?? 0).toDouble(),
      payments: ((data['payments'] as num?) ?? 0).toDouble(),
      previousCash: ((data['previousCash'] as num?) ?? 0).toDouble(),
      cashAvailable: ((data['cashAvailable'] as num?) ?? 0).toDouble(),
      balance: ((data['balance'] as num?) ?? 0).toDouble(),
      remarks: (data['remarks'] as String?) ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

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

  Map<String, dynamic> toFirestoreWrite() {
    return {
      'serial': serial,
      'date': Timestamp.fromDate(date),
      'amountReceived': amountReceived,
      'payments': payments,
      'previousCash': previousCash,
      'cashAvailable': cashAvailable,
      'balance': balance,
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
