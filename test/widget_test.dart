import 'package:agri_ledger/app/app.dart';
import 'package:flutter_test/flutter_test.dart';

import 'firebase_test_setup.dart';

void main() {
  setUpAll(() async {
    await ensureFirebaseInitializedForTests();
  });

  testWidgets('App boots', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump();

    expect(find.text('AgriLedger'), findsOneWidget);
  });
}
