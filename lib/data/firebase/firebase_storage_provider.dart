import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../core/error/app_error.dart';
import '../../domain/repositories/storage_provider.dart';
import '../../firebase_options.dart';

/// Firebase [StorageProvider]: uploads receipt bytes to Cloud Storage under
/// `users/{uid}/shipments/{shipmentId}/receipts/{fileName}` and returns the
/// download URL.
class FirebaseStorageProvider implements StorageProvider {
  FirebaseStorageProvider({
    FirebaseStorage? storage,
    FirebaseAuth? auth,
  })  : _injectedStorage = storage,
        _auth = auth ?? FirebaseAuth.instance;

  final FirebaseStorage? _injectedStorage;
  final FirebaseAuth _auth;

  // Resolved lazily so constructing the provider never requires an initialized
  // Firebase app (e.g. when the Firebase backend is registered but unused).
  FirebaseStorage get _storage => _injectedStorage ?? _defaultStorage();

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
      throw const NotSignedInError();
    }
    return uid;
  }

  Reference _shipmentReceiptsRef(String shipmentId) {
    return _storage.ref('users/$_uid/shipments/$shipmentId/receipts');
  }

  @override
  Future<String> uploadShipmentReceipt({
    required String shipmentId,
    required String fileName,
    required Uint8List bytes,
  }) async {
    try {
      final ref = _shipmentReceiptsRef(shipmentId).child(fileName);
      await ref.putData(
        bytes,
        SettableMetadata(contentDisposition: 'inline'),
      );
      return ref.getDownloadURL();
    } on FirebaseException catch (e) {
      throw StorageFailedError(cause: e);
    }
  }
}
