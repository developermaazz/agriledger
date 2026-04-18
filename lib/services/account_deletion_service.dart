import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../firebase_options.dart';

/// Deletes the signed-in user's Firestore tree, Storage files, and Auth record.
/// Caller must supply the account password for [reauthenticate].
class AccountDeletionService {
  AccountDeletionService({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
    FirebaseStorage? storage,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance,
        _storage = storage ?? _defaultStorage();

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final FirebaseStorage _storage;

  static FirebaseStorage _defaultStorage() {
    final options = DefaultFirebaseOptions.currentPlatform;
    final bucket = options.storageBucket;
    if (bucket == null || bucket.isEmpty) {
      return FirebaseStorage.instance;
    }
    return FirebaseStorage.instanceFor(
      app: Firebase.app(),
      bucket: 'gs://$bucket',
    );
  }

  /// Full account removal. Throws [FirebaseAuthException] on bad password, etc.
  Future<void> deleteAccountWithPassword(String password) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw StateError('Not signed in');
    }
    final email = user.email;
    if (email == null || email.isEmpty) {
      throw StateError('Email account required');
    }

    final cred = EmailAuthProvider.credential(
      email: email.trim(),
      password: password,
    );
    await user.reauthenticateWithCredential(cred);

    final uid = user.uid;
    await _wipeFirestore(uid);
    await _wipeStoragePrefix('users/$uid');
    await user.delete();
  }

  Future<void> _wipeFirestore(String uid) async {
    final root = _firestore.collection('users').doc(uid);

    await _deleteQueryCollection(root.collection('shipments'));
    await _deleteQueryCollection(root.collection('labourJobs'));

    final markets = await root.collection('markets').get();
    for (final m in markets.docs) {
      await _deleteQueryCollection(m.reference.collection('cashEntries'));
      await m.reference.delete();
    }

    await _deleteQueryCollection(root.collection('meta'));
    await root.delete();
  }

  Future<void> _deleteQueryCollection(
    CollectionReference<Map<String, dynamic>> col,
  ) async {
    while (true) {
      final snap = await col.limit(400).get();
      if (snap.docs.isEmpty) {
        return;
      }
      final batch = _firestore.batch();
      for (final d in snap.docs) {
        batch.delete(d.reference);
      }
      await batch.commit();
    }
  }

  Future<void> _wipeStoragePrefix(String path) async {
    try {
      await _deleteStorageFolder(_storage.ref(path));
    } on FirebaseException catch (e) {
      if (e.code == 'object-not-found') {
        return;
      }
      rethrow;
    }
  }

  Future<void> _deleteStorageFolder(Reference ref) async {
    final list = await ref.listAll();
    for (final item in list.items) {
      await item.delete();
    }
    for (final prefix in list.prefixes) {
      await _deleteStorageFolder(prefix);
    }
  }
}
