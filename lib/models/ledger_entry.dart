import 'package:cloud_firestore/cloud_firestore.dart';

enum LedgerEntryType { credit, debit }

LedgerEntryType ledgerEntryTypeFromString(String value) {
  return value == 'debit' ? LedgerEntryType.debit : LedgerEntryType.credit;
}

class LedgerEntry {
  const LedgerEntry({
    required this.id,
    required this.type,
    required this.amount,
    required this.description,
    required this.entryDate,
    required this.createdAt,
  });

  final String id;
  final LedgerEntryType type;
  final double amount;
  final String description;
  final DateTime entryDate;
  final DateTime? createdAt;

  String get typeLabel => type == LedgerEntryType.credit ? 'Credit' : 'Debit';

  double get signedAmount => type == LedgerEntryType.credit ? amount : -amount;

  factory LedgerEntry.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? <String, dynamic>{};

    return LedgerEntry(
      id: doc.id,
      type: ledgerEntryTypeFromString((data['type'] as String?) ?? 'credit'),
      amount: ((data['amount'] as num?) ?? 0).toDouble(),
      description: (data['description'] as String?) ?? '',
      entryDate: ((data['entryDate'] as Timestamp?) ?? Timestamp.now()).toDate(),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestoreForCreate() {
    return {
      'type': type.name,
      'amount': amount,
      'description': description,
      'entryDate': Timestamp.fromDate(entryDate),
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
