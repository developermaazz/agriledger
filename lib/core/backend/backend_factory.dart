import 'backend.dart';
import 'backend_kind.dart';

/// Builds the [Backend] for one [BackendKind].
///
/// Implementations live with their backend (e.g. `data/firebase`,
/// `data/local`) and are wired in the composition root
/// (`lib/app/backend_registrations.dart`).
abstract interface class BackendFactory {
  BackendKind get kind;

  /// Constructs and initializes the backend. Any one-time setup (Firebase init,
  /// opening a local database) must complete before this resolves.
  Future<Backend> build();
}
