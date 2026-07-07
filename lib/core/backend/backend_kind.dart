/// The available data backends. The selected kind determines which set of
/// store implementations the app runs against.
enum BackendKind {
  /// On-device store. No network, no Firebase configuration required.
  local,

  /// Firebase (Cloud Firestore + Firebase Auth + Cloud Storage).
  firebase,

  /// Placeholder for a future custom backend (REST / Supabase / …).
  custom;

  /// Resolves a persisted/`dart-define` name to a kind, falling back to
  /// [defaultBackendKind] for unknown/empty values.
  static BackendKind fromName(String? name) => BackendKind.values.firstWhere(
        (k) => k.name == name,
        orElse: () => defaultBackendKind,
      );
}

/// The compile-time default backend (the shipped default). Overridable at
/// runtime via the persisted setting or a `--dart-define=BACKEND=...` at boot.
///
/// The app ships on the on-device [BackendKind.local] backend so it runs
/// out-of-the-box with zero Firebase configuration.
const BackendKind defaultBackendKind = BackendKind.local;
