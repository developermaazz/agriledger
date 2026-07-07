import 'package:flutter/foundation.dart';

import 'backend_kind.dart';

/// UI-facing controller for the active data backend. Exposes the current kind,
/// the switchable options, and an in-progress flag. The actual backend swap is
/// performed by `AppBootstrap` via [_onSwitch].
class BackendController extends ChangeNotifier {
  BackendController({
    required BackendKind current,
    required this.available,
    required Future<void> Function(BackendKind kind) onSwitch,
  })  : _current = current,
        _onSwitch = onSwitch;

  BackendKind _current;
  bool _switching = false;
  final List<BackendKind> available;
  final Future<void> Function(BackendKind kind) _onSwitch;

  BackendKind get current => _current;
  bool get switching => _switching;

  /// Switches the active backend. Rethrows on failure (e.g. Firebase not
  /// configured for this platform) so the caller can surface the error.
  Future<void> switchTo(BackendKind kind) async {
    if (kind == _current || _switching) {
      return;
    }
    _switching = true;
    notifyListeners();
    try {
      await _onSwitch(kind);
      _current = kind;
    } finally {
      _switching = false;
      notifyListeners();
    }
  }
}
