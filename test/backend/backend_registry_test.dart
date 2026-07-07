import 'package:agri_ledger/app/backend_registrations.dart';
import 'package:agri_ledger/core/backend/backend_kind.dart';
import 'package:agri_ledger/core/backend/backend_registry.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('registerBackends registers local + firebase', () {
    registerBackends();
    expect(BackendRegistry.isRegistered(BackendKind.local), isTrue);
    expect(BackendRegistry.isRegistered(BackendKind.firebase), isTrue);
    expect(BackendRegistry.available, containsAll([
      BackendKind.local,
      BackendKind.firebase,
    ]));
  });

  test('the shipped default backend is local', () {
    expect(defaultBackendKind, BackendKind.local);
  });

  test('create() throws for an unregistered backend', () {
    expect(
      () => BackendRegistry.create(BackendKind.custom),
      throwsStateError,
    );
  });

  test('BackendKind.fromName resolves known names and falls back to default',
      () {
    expect(BackendKind.fromName('local'), BackendKind.local);
    expect(BackendKind.fromName('firebase'), BackendKind.firebase);
    expect(BackendKind.fromName('custom'), BackendKind.custom);
    expect(BackendKind.fromName('nonsense'), defaultBackendKind);
    expect(BackendKind.fromName(null), defaultBackendKind);
  });
}
