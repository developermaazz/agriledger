import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/entities/cash_entry.dart';
import '../../../domain/entities/labour_job.dart';
import '../../../domain/entities/market.dart';
import '../../../domain/entities/shipment.dart';
import '../../../domain/record_status.dart';

/// Firestore <-> entity serialization. This is the ONLY place that knows about
/// `Timestamp` / `FieldValue.serverTimestamp()`; entities stay backend-neutral.
/// The exact document shapes are preserved from the original repositories.

// ---------------------------------------------------------------------------
// Shipment
// ---------------------------------------------------------------------------
Shipment shipmentFromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
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

Map<String, dynamic> shipmentToFirestoreWrite(Shipment s) {
  final d = Shipment.derivedFields(
    totalAmount: s.totalAmount,
    amountReceived: s.amountReceived,
  );
  return {
    'serial': s.serial,
    'date': Timestamp.fromDate(s.date),
    'marketId': s.marketId,
    'marketName': s.marketName,
    'buyerName': s.buyerName,
    'quantity': s.quantity,
    'totalAmount': s.totalAmount,
    'amountReceived': s.amountReceived,
    'balance': d['balance'],
    'status': d['status'],
    'remarks': s.remarks,
    'updatedAt': FieldValue.serverTimestamp(),
  };
}

Map<String, dynamic> shipmentToFirestoreCreate(Shipment s) => {
      ...shipmentToFirestoreWrite(s),
      'createdAt': FieldValue.serverTimestamp(),
    };

// ---------------------------------------------------------------------------
// Market
// ---------------------------------------------------------------------------
Market marketFromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
  final data = doc.data() ?? {};
  return Market(
    id: doc.id,
    name: (data['name'] as String?) ?? '',
    cashSerialNext: (data['cashSerialNext'] as int?) ?? 1,
    createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
  );
}

Map<String, dynamic> marketToFirestoreCreate(Market m) => {
      'name': m.name,
      'cashSerialNext': m.cashSerialNext,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };

// ---------------------------------------------------------------------------
// CashEntry
// ---------------------------------------------------------------------------
CashEntry cashEntryFromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
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

Map<String, dynamic> cashEntryToFirestoreWrite(CashEntry e) => {
      'serial': e.serial,
      'date': Timestamp.fromDate(e.date),
      'amountReceived': e.amountReceived,
      'payments': e.payments,
      'previousCash': e.previousCash,
      'cashAvailable': e.cashAvailable,
      'balance': e.balance,
      'remarks': e.remarks,
      'updatedAt': FieldValue.serverTimestamp(),
    };

Map<String, dynamic> cashEntryToFirestoreCreate(CashEntry e) => {
      ...cashEntryToFirestoreWrite(e),
      'createdAt': FieldValue.serverTimestamp(),
    };

// ---------------------------------------------------------------------------
// LabourJob
// ---------------------------------------------------------------------------
LabourJob labourFromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
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

Map<String, dynamic> labourToFirestoreWrite(LabourJob j) {
  final d = LabourJob.derivedFields(
    totalCost: j.totalCost,
    receivedPayment: j.receivedPayment,
  );
  return {
    'serial': j.serial,
    'dateStart': Timestamp.fromDate(j.dateStart),
    'dateEnd': Timestamp.fromDate(j.dateEnd),
    'totalCost': j.totalCost,
    'receivedPayment': j.receivedPayment,
    'remainingBalance': d['remainingBalance'],
    'status': d['status'],
    'remarks': j.remarks,
    'updatedAt': FieldValue.serverTimestamp(),
  };
}

Map<String, dynamic> labourToFirestoreCreate(LabourJob j) => {
      ...labourToFirestoreWrite(j),
      'createdAt': FieldValue.serverTimestamp(),
    };
