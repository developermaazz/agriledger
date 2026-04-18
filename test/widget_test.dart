import 'package:agri_ledger/app/app.dart';
import 'package:agri_ledger/services/auth_deep_link_handler.dart';
import 'package:agri_ledger/shared/widgets/app_brand.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_test_setup.dart';

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({'require_email_login': true});
    await ensureFirebaseInitializedForTests();
  });

  testWidgets('App boots to sign-in', (WidgetTester tester) async {
    await tester.pumpWidget(
      MyApp(authDeepLinkHandler: AuthDeepLinkHandler()),
    );
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(AppLogoMark), findsOneWidget);
  });
}
