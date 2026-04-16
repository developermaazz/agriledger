import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/record_status.dart';

class LabourJob {
  const LabourJob({
    required this.id,
    required this.serial,
    required this.dateStart,
    required this.dateEnd,
    required this.totalCost,
    required this.receivedPayment,
    required this.remainingBalance,
    required this.status,
    required this.remarks,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final int serial;
  final DateTime dateStart;
  final DateTime dateEnd;
  final double totalCost;
  final double receivedPayment;
  final double remainingBalance;
  final String status;
  final String remarks;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory LabourJob.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return LabourJob(
      id: doc.id,
      serial: (data['serial'] as int?) ?? 0,
      dateStart: ((data['dateStart'] as Timestamp?) ?? Timestamp.now()).toDate(),
      dateEnd: ((data['dateEnd'] as Timestamp?) ?? Timestamp.now()).toDate(),
      totalCost: ((data['totalCost'] as num?) ?? 0).toDouble(),
      receivedPayment: ((data['receivedPayment'] as num?) ?? 0).toDouble(),
      remainingBalance: ((data['remainingBalance'] as num?) ?? 0).toDouble(),
      status: (data['status'] as String?) ?? RecordStatuses.pending,
      remarks: (data['remarks'] as String?) ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  static Map<String, dynamic> derivedFields({
    required double totalCost,
    required double receivedPayment,
  }) {
    final remaining = totalCost - receivedPayment;
    return {
      'remainingBalance': remaining,
      'status': statusFromBalance(remaining),
    };
  }

  Map<String, dynamic> toFirestoreWrite() {
    final d = derivedFields(
      totalCost: totalCost,
      receivedPayment: receivedPayment,
    );
    return {
      'serial': serial,
      'dateStart': Timestamp.fromDate(dateStart),
      'dateEnd': Timestamp.fromDate(dateEnd),
      'totalCost': totalCost,
      'receivedPayment': receivedPayment,
      'remainingBalance': d['remainingBalance'],
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
