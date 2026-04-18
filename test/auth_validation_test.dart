import 'package:agri_ledger/domain/auth_validation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('email validation', () {
    expect(AuthValidation.isValidEmail('a@b.co'), isTrue);
    expect(AuthValidation.isValidEmail('bad'), isFalse);
  });

  test('password acceptable', () {
    expect(AuthValidation.isPasswordAcceptable('short'), isFalse);
    expect(AuthValidation.isPasswordAcceptable('GoodPass1'), isTrue);
  });
}
