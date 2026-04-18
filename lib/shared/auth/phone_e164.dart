import 'package:phone_numbers_parser/phone_numbers_parser.dart';

/// Normalizes user input to E.164 for Pakistan-first UX ([iso] defaults to PK).
String? tryParseToE164(String raw, {IsoCode iso = IsoCode.PK}) {
  final t = raw.trim();
  if (t.isEmpty) return null;
  try {
    final p = PhoneNumber.parse(t, callerCountry: iso);
    return p.international.replaceAll(' ', '');
  } on Exception {
    return null;
  }
}
