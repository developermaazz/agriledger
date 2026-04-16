import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/farmer.dart';

class FarmerRepository {
  FarmerRepository({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  String get _uid {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      throw StateError('Not signed in');
    }
    return uid;
  }

  CollectionReference<Map<String, dynamic>> get _farmersCol =>
      _firestore.collection('users').doc(_uid).collection('farmers');

  Stream<List<Farmer>> watchFarmers() {
    return _farmersCol
        .orderBy('name')
        .snapshots()
        .map((snapshot) => snapshot.docs.map(Farmer.fromFirestore).toList());
  }

  Stream<Farmer> watchFarmer(String farmerId) {
    return _farmersCol.doc(farmerId).snapshots().map(Farmer.fromFirestore);
  }

  Future<String> createFarmer(Farmer farmer) async {
    final doc = _farmersCol.doc();
    await doc.set(farmer.copyWith(id: doc.id).toFirestoreForCreate());
    return doc.id;
  }

  Future<void> updateFarmer(Farmer farmer) {
    return _farmersCol.doc(farmer.id).update(farmer.toFirestoreForUpdate());
  }

  Future<void> updateFarmerBalance({
    required String farmerId,
    required double newBalance,
  }) {
    return _farmersCol.doc(farmerId).update({
      'currentBalance': newBalance,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}

extension on Farmer {
  Farmer copyWith({
    String? id,
    String? name,
    String? phone,
    String? address,
    String? notes,
    double? openingBalance,
    double? currentBalance,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Farmer(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      notes: notes ?? this.notes,
      openingBalance: openingBalance ?? this.openingBalance,
      currentBalance: currentBalance ?? this.currentBalance,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
