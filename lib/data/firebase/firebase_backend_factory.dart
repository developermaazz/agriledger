import '../../core/backend/backend.dart';
import '../../core/backend/backend_factory.dart';
import '../../core/backend/backend_kind.dart';
import 'firebase_auth_provider.dart';
import 'firebase_labour_store.dart';
import 'firebase_market_cash_store.dart';
import 'firebase_market_store.dart';
import 'firebase_serial_meta_store.dart';
import 'firebase_shipment_store.dart';
import 'firebase_storage_provider.dart';

/// Builds the Firebase [Backend].
///
/// `Firebase.initializeApp` must have completed before [build] is called — the
/// stores read `FirebaseFirestore.instance` / `FirebaseAuth.instance`.
class FirebaseBackendFactory implements BackendFactory {
  @override
  BackendKind get kind => BackendKind.firebase;

  @override
  Future<Backend> build() async {
    final serialMeta = FirebaseSerialMetaStore();
    final markets = FirebaseMarketStore();
    final shipments = FirebaseShipmentStore(serialMeta: serialMeta);
    final labour = FirebaseLabourStore(serialMeta: serialMeta);
    final marketCash = FirebaseMarketCashStore(marketStore: markets);
    return Backend(
      kind: kind,
      auth: FirebaseAuthProvider(),
      shipments: shipments,
      markets: markets,
      marketCash: marketCash,
      labour: labour,
      serialMeta: serialMeta,
      storage: FirebaseStorageProvider(),
    );
  }
}
