import 'package:agri_ledger/app/app.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_test_setup.dart';

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({'require_email_login': true});
    await ensureFirebaseInitializedForTests();
  });

  testWidgets('App boots to sign-in', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Fruit Ledger'), findsOneWidget);
  });
}
