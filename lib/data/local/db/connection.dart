/// Platform-conditional drift connection. `openLocalDatabase()` resolves to the
/// native (mobile/desktop/tests) or web implementation at compile time, so the
/// local backend compiles on every platform.
library;

export 'connection/unsupported.dart'
    if (dart.library.io) 'connection/native.dart'
    if (dart.library.js_interop) 'connection/web.dart';
