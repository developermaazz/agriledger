import 'dart:math';

int _seq = 0;
final Random _rand = Random();

/// Generates a locally-unique record id (time + sequence + random), replacing
/// Firestore's auto-ids for the on-device backend.
String newLocalId() {
  final now = DateTime.now().microsecondsSinceEpoch;
  _seq = (_seq + 1) & 0xffffff;
  final r = _rand.nextInt(0xffffff);
  return '${now.toRadixString(16)}-${_seq.toRadixString(16)}-${r.toRadixString(16)}';
}
