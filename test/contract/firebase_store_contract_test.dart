import 'package:agri_ledger/core/backend/backend.dart';
import 'package:agri_ledger/core/backend/backend_kind.dart';
import 'package:agri_ledger/data/firebase/firebase_auth_provider.dart';
import 'package:agri_ledger/data/firebase/firebase_labour_store.dart';
import 'package:agri_ledger/data/firebase/firebase_market_cash_store.dart';
import 'package:agri_ledger/data/firebase/firebase_market_store.dart';
import 'package:agri_ledger/data/firebase/firebase_serial_meta_store.dart';
import 'package:agri_ledger/data/firebase/firebase_shipment_store.dart';
import 'package:agri_ledger/data/firebase/firebase_storage_provider.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';

import 'store_contract.dart';

/// Runs the shared store contract against the FIREBASE backend, using in-memory
/// fakes (FakeFirebaseFirestore + MockFirebaseAuth) so it executes headlessly.
Future<Backend> _makeFirebaseFake() async {
  final firestore = FakeFirebaseFirestore();
  final auth = MockFirebaseAuth(
    signedIn: true,
    mockUser: MockUser(uid: 'test-uid', isAnonymous: true),
  );

  final serialMeta = FirebaseSerialMetaStore(firestore: firestore, auth: auth);
  final markets = FirebaseMarketStore(firestore: firestore, auth: auth);
  final shipments = FirebaseShipmentStore(
    firestore: firestore,
    auth: auth,
    serialMeta: serialMeta,
  );
  final labour = FirebaseLabourStore(
    firestore: firestore,
    auth: auth,
    serialMeta: serialMeta,
  );
  final cash = FirebaseMarketCashStore(
    firestore: firestore,
    auth: auth,
    marketStore: markets,
  );

  return Backend(
    kind: BackendKind.firebase,
    auth: FirebaseAuthProvider(auth: auth),
    shipments: shipments,
    markets: markets,
    marketCash: cash,
    labour: labour,
    serialMeta: serialMeta,
    storage: FirebaseStorageProvider(auth: auth),
  );
}

void main() {
  runStoreContractTests('firebase-fake', _makeFirebaseFake);
}
