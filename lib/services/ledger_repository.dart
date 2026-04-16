import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/ledger_entry.dart';

class LedgerRepository {
  LedgerRepository({
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

  CollectionReference<Map<String, dynamic>> _entriesCol(String farmerId) {
    return _firestore
        .collection('users')
        .doc(_uid)
        .collection('farmers')
        .doc(farmerId)
        .collection('entries');
  }

  Stream<List<LedgerEntry>> watchEntries(String farmerId) {
    return _entriesCol(farmerId)
        .orderBy('entryDate', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map(LedgerEntry.fromFirestore).toList(),
        );
  }

  Future<void> addEntryAndUpdateBalance({
    required String farmerId,
    required LedgerEntry entry,
    required double newFarmerBalance,
  }) {
    final batch = _firestore.batch();
    final entryRef = _entriesCol(farmerId).doc();
    batch.set(entryRef, entry.copyWith(id: entryRef.id).toFirestoreForCreate());
    batch.update(
      _firestore.collection('users').doc(_uid).collection('farmers').doc(farmerId),
      {
        'currentBalance': newFarmerBalance,
        'updatedAt': FieldValue.serverTimestamp(),
      },
    );
    return batch.commit();
  }
}

extension on LedgerEntry {
  LedgerEntry copyWith({
    String? id,
    LedgerEntryType? type,
    double? amount,
    String? description,
    DateTime? entryDate,
    DateTime? createdAt,
  }) {
    return LedgerEntry(
      id: id ?? this.id,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      entryDate: entryDate ?? this.entryDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
