import 'dart:typed_data';

/// Backend-agnostic receipt/attachment storage contract.
///
/// Returns a stable reference to the stored bytes — a download URL on Firebase,
/// a local file path on the on-device backend. No backend handle types leak.
abstract interface class StorageProvider {
  Future<String> uploadShipmentReceipt({
    required String shipmentId,
    required String fileName,
    required Uint8List bytes,
  });
}
