# Agri Ledger

Shipments, market cash, and labour ledgers in one app. Built with Flutter,
Material 3, English + Urdu (RTL), light/dark themes.

## Runs out-of-the-box (no Firebase needed)

The app ships on an **on-device local backend** (SQLite via drift), so it runs
with zero configuration on every platform — including desktop:

```bash
flutter pub get
dart run build_runner build   # generates the drift database code
flutter run                   # phone, desktop, or web
```

A fresh install seeds sample data and is immediately usable offline.

> **Web:** the local backend compiles for web via WebAssembly SQLite, but running
> it needs `sqlite3.wasm` and `drift_worker.js` in `web/` (fetch the pair for the
> installed drift version — see the [drift web docs](https://drift.simonbinder.eu/web/)).
> Mobile, desktop, and tests need no extra setup.

## Backends

Data/auth/storage sit behind backend-agnostic interfaces. Choose a backend:

- **Default (local):** nothing to configure.
- **Firebase:** run with `--dart-define=BACKEND=firebase` (requires the usual
  FlutterFire/`google-services` setup), or switch at runtime in
  **Settings → Developer → Data backend**. Data can be moved between backends
  via **Settings → Developer → Export / Import**.

See [ARCHITECTURE.md](ARCHITECTURE.md) for the bridge design, how to switch
backends, and how to add a new one (e.g. REST/Supabase).

## Development

```bash
flutter analyze
flutter test                          # includes the cross-backend contract suite
dart run build_runner build           # after changing drift tables
flutter gen-l10n                       # after editing lib/l10n/*.arb
```

Tests include a **contract suite** (`test/contract/`) that runs the same
assertions against both the local and (fake) Firebase backends to prove they are
interchangeable.
