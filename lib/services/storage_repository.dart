import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../firebase_options.dart';

/// Placeholder for future receipt/attachment uploads.
class StorageRepository {
  StorageRepository({
    FirebaseStorage? storage,
    FirebaseAuth? auth,
  })  : _storage = storage ?? _defaultStorage(),
        _auth = auth ?? FirebaseAuth.instance;

  final FirebaseStorage _storage;
  final FirebaseAuth _auth;

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

  String get _uid {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      throw StateError('Not signed in');
    }
    return uid;
  }

  Reference farmerReceiptsRef(String farmerId) {
    return _storage.ref('users/$_uid/farmers/$farmerId/receipts');
  }

  Future<String> uploadFarmerReceipt({
    required String farmerId,
    required String fileName,
    required Uint8List bytes,
  }) async {
    final ref = farmerReceiptsRef(farmerId).child(fileName);
    await ref.putData(
      bytes,
      SettableMetadata(contentDisposition: 'inline'),
    );
    return ref.getDownloadURL();
  }
}
