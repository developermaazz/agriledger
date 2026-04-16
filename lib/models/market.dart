import 'package:cloud_firestore/cloud_firestore.dart';

class Market {
  const Market({
    required this.id,
    required this.name,
    required this.cashSerialNext,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String name;
  final int cashSerialNext;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory Market.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return Market(
      id: doc.id,
      name: (data['name'] as String?) ?? '',
      cashSerialNext: (data['cashSerialNext'] as int?) ?? 1,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestoreCreate() {
    return {
      'name': name,
      'cashSerialNext': cashSerialNext,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  Map<String, dynamic> toFirestoreUpdateName() {
    return {
      'name': name,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}
