import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_profile.dart';

class UserProfileRepository {
  UserProfileRepository({FirebaseFirestore? firestore, FirebaseAuth? auth})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  DocumentReference<Map<String, dynamic>>? _docRef() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return null;
    return _firestore.collection('users').doc(uid);
  }

  Stream<UserProfile?> profileStream() {
    final ref = _docRef();
    if (ref == null) {
      return const Stream.empty();
    }
    return ref.snapshots().map((s) => UserProfile.fromMap(s.data()));
  }

  Future<UserProfile?> getProfileOnce() async {
    final ref = _docRef();
    if (ref == null) return null;
    final s = await ref.get();
    return UserProfile.fromMap(s.data());
  }

  Future<void> upsertProfile({
    required String name,
    required String email,
    required String phoneE164,
  }) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;
    await _firestore.collection('users').doc(uid).set(
      <String, dynamic>{
        'name': name.trim(),
        'email': email.trim().toLowerCase(),
        'phoneE164': phoneE164.trim(),
        'isVerified': false,
        'updatedAt': FieldValue.serverTimestamp(),
        'createdAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }
}
