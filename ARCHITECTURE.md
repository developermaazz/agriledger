# Agri Ledger — Architecture

Agri Ledger runs on a **backend bridge**: all data, auth, and storage sit behind
backend-agnostic interfaces, with an on-device **local** store as the shipped
default and **Firebase** as a pluggable alternative selected via config. The app
runs out-of-the-box with **zero Firebase configuration**.

## Layers

```
lib/
  app/            Composition root: MaterialApp (AppView), AppBootstrap (owns the
                  active backend + DI), backend_registrations, theme/.
  core/
    error/        AppError (sealed, typed) + localized message mapping.
    backend/      BackendKind, Backend (bundle), BackendFactory, BackendRegistry,
                  BackendController (runtime switching).
  domain/
    entities/     Backend-neutral models (toJson/fromJson, epoch-millis dates).
    value/        AuthUser.
    repositories/ The CONTRACTS — one interface per data concern.
    services/     Pure business logic (cash_ledger_math, record_status,
                  date_range_utils).
  data/
    firebase/     Firebase implementations + Firestore mappers (the only place
                  that knows about Timestamp / serverTimestamp).
    local/        drift (SQLite) implementations + db schema, session, seed.
    settings/     shared_preferences settings store (device-local, shared).
    export/       Excel/PDF export (backend-neutral).
    migration/    JSON export/import between backends.
    refresh/      pull-to-refresh helper.
  features/       Presentation, feature-first (unchanged tree).
  shared/         responsive/ (breakpoints, adaptive nav, max-width), widgets/,
                  formatters/, snackbar/, l10n/.
```

Dependencies point inward: `features` → `domain` (interfaces) + `core`;
`data` → `domain` + `core`; `app` wires everything (the only layer that knows
concrete backends).

## The contracts

One interface per data concern, all Firebase-free in their signatures
(`lib/domain/repositories/`):

`AuthProvider`, `ShipmentStore`, `MarketStore`, `MarketCashStore`,
`LabourStore`, `SerialMetaStore`, `SettingsStore`, `StorageProvider`.

They expose the same `Stream<List<T>>` / `Future<T>` shapes the UI already used,
so screens don't know or care which backend is active. Failures are raised as
typed `AppError`s (e.g. `RecordLockedError`, `MarketInUseError`,
`NotSignedInError`, `AuthError`) which the UI maps to localized (en + ur)
messages.

## Selecting a backend

`BackendKind { local, firebase, custom }`. Resolution order at startup
(`lib/main.dart`):

1. `--dart-define=BACKEND=firebase` (or `local`) — compile/run override.
2. The persisted `SettingsStore.backendKind` (set from the Settings screen).
3. `defaultBackendKind` (compile-time default = **local**).

Firebase is only initialized when the Firebase backend is actually selected, so
the local default requires no `google-services` files and works on every
platform including desktop (which Firebase does not support here).

## Switching backends at runtime

The **Settings → Developer** section shows the active backend and a switcher.
`BackendController.switchTo(kind)` → `AppBootstrap._performSwitch`:

1. `ensureBackendReady(kind)` (e.g. lazily `Firebase.initializeApp` on first use),
2. build the new `Backend` from the registry,
3. persist the new kind,
4. swap it into the widget tree and dispose the old backend.

A JSON **migration** (Settings → Developer → Export / Import, or
`MigrationService`) moves all data between backends. Import goes through the
stores, so serials are re-allocated in original order and the cash chain is
recomputed; the data is preserved and internally consistent (it adds to the
target, it does not wipe it).

## Adding a new backend (e.g. REST / Supabase)

1. Implement the seven store interfaces (`AuthProvider`, `*Store`,
   `StorageProvider`) under `lib/data/<your_backend>/`.
2. Add a `BackendFactory` whose `build()` constructs and returns a `Backend`
   bundle (with an `onDispose` to release resources).
3. Register **one line** in `lib/app/backend_registrations.dart`:
   ```dart
   BackendRegistry.register(BackendKind.custom, () => MyBackendFactory());
   ```
4. (Optional) add a localized label in `_DeveloperSection._label` and the ARB
   files. That's it — the Settings switcher and everything else pick it up.

Keep serialization backend-specific to your adapter (mappers). Entities stay
neutral (`toJson`/`fromJson` with epoch-millis dates).

## Local backend notes

- SQLite via **drift**; schema in `lib/data/local/db/app_database.dart`
  (generated `*.g.dart` via `dart run build_runner build`).
- All user data is scoped by `ownerUid` to mirror Firebase's `users/{uid}/…`
  partitioning (anonymous and email accounts get separate data).
- Local auth = on-device accounts (salted SHA-256 password hash) + a persisted
  single session. Serial allocation and cash-chain recompute run inside drift
  transactions. Receipts are written to the app documents directory.
- A fresh (first) account is seeded with sample data so the app is immediately
  usable offline.

## Preserved business rules

Serial numbering, the completed-record edit/delete guard, balance/status
derivation, the cash running-balance chain, market referential-delete guard,
ordering, and money formatting are identical across backends — proven by a
single **contract test suite** (`test/contract/`) run against both the local and
(fake) Firebase implementations.
