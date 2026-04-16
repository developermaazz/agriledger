import 'package:cloud_firestore/cloud_firestore.dart';

class Farmer {
  const Farmer({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
    required this.notes,
    required this.openingBalance,
    required this.currentBalance,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String name;
  final String phone;
  final String address;
  final String notes;
  final double openingBalance;
  final double currentBalance;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  bool get hasReceivable => currentBalance > 0;

  factory Farmer.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? <String, dynamic>{};

    return Farmer(
      id: doc.id,
      name: (data['name'] as String?) ?? '',
      phone: (data['phone'] as String?) ?? '',
      address: (data['address'] as String?) ?? '',
      notes: (data['notes'] as String?) ?? '',
      openingBalance: ((data['openingBalance'] as num?) ?? 0).toDouble(),
      currentBalance: ((data['currentBalance'] as num?) ?? 0).toDouble(),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestoreForCreate() {
    return {
      'name': name,
      'phone': phone,
      'address': address,
      'notes': notes,
      'openingBalance': openingBalance,
      'currentBalance': currentBalance,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  Map<String, dynamic> toFirestoreForUpdate() {
    return {
      'name': name,
      'phone': phone,
      'address': address,
      'notes': notes,
      'openingBalance': openingBalance,
      'currentBalance': currentBalance,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}
