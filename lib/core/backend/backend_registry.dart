import 'backend.dart';
import 'backend_factory.dart';
import 'backend_kind.dart';

typedef BackendFactoryBuilder = BackendFactory Function();

/// Registry of available backends.
///
/// To add a new backend (e.g. REST/Supabase): implement the store interfaces +
/// a [BackendFactory], then register ONE entry in
/// `lib/app/backend_registrations.dart`:
/// ```dart
/// BackendRegistry.register(BackendKind.custom, () => MyBackendFactory());
/// ```
class BackendRegistry {
  BackendRegistry._();

  static final Map<BackendKind, BackendFactoryBuilder> _builders = {};

  static void register(BackendKind kind, BackendFactoryBuilder builder) =>
      _builders[kind] = builder;

  static bool isRegistered(BackendKind kind) => _builders.containsKey(kind);

  static Iterable<BackendKind> get available => _builders.keys;

  /// Builds the [Backend] for [kind]. Throws if no backend is registered.
  static Future<Backend> create(BackendKind kind) {
    final builder = _builders[kind];
    if (builder == null) {
      throw StateError('No backend registered for "${kind.name}"');
    }
    return builder().build();
  }
}
