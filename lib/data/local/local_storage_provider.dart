import 'dart:io';
import 'dart:typed_data';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../core/error/app_error.dart';
import '../../domain/repositories/storage_provider.dart';

/// Local [StorageProvider]: writes receipt bytes to the app documents directory
/// under `receipts/{uid}/{shipmentId}/{fileName}` and returns the file path.
class LocalStorageProvider implements StorageProvider {
  LocalStorageProvider({required this.currentUid});

  final String Function() currentUid;

  @override
  Future<String> uploadShipmentReceipt({
    required String shipmentId,
    required String fileName,
    required Uint8List bytes,
  }) async {
    final uid = currentUid();
    try {
      final dir = await getApplicationDocumentsDirectory();
      final target = Directory(p.join(dir.path, 'receipts', uid, shipmentId));
      await target.create(recursive: true);
      final file = File(p.join(target.path, fileName));
      await file.writeAsBytes(bytes, flush: true);
      return file.path;
    } on FileSystemException catch (e) {
      throw StorageFailedError(cause: e);
    }
  }
}
