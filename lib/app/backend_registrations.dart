import '../core/backend/backend_kind.dart';
import '../core/backend/backend_registry.dart';
import '../data/firebase/firebase_backend_factory.dart';
import '../data/local/local_backend_factory.dart';

/// Wires each available backend into the [BackendRegistry]. This is the single
/// composition-root place that knows about concrete backend factories.
///
/// To add a new backend: implement the store interfaces + a `BackendFactory`,
/// then add ONE line here.
void registerBackends() {
  BackendRegistry.register(
    BackendKind.local,
    () => LocalBackendFactory(),
  );
  BackendRegistry.register(
    BackendKind.firebase,
    () => FirebaseBackendFactory(),
  );
}
