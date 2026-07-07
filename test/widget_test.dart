import 'package:agri_ledger/app/app_bootstrap.dart';
import 'package:agri_ledger/app/backend_registrations.dart';
import 'package:agri_ledger/core/backend/backend_kind.dart';
import 'package:agri_ledger/core/backend/backend_registry.dart';
import 'package:agri_ledger/data/local/db/app_database.dart';
import 'package:agri_ledger/data/local/local_backend_factory.dart';
import 'package:agri_ledger/data/settings/prefs_settings_store.dart';
import 'package:agri_ledger/shared/widgets/app_brand.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_test_setup.dart';

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({'require_email_login': true});
    await ensureFirebaseInitializedForTests();
    registerBackends();
  });

  testWidgets('App boots to sign-in', (WidgetTester tester) async {
    final settings = PrefsSettingsStore();
    final backend = await BackendRegistry.create(BackendKind.firebase);

    await tester.pumpWidget(
      AppBootstrap(
        settings: settings,
        initialBackend: backend,
        ensureBackendReady: (_) async {},
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(AppLogoMark), findsOneWidget);
  });

  testWidgets('local backend (shipped default) boots to sign-in',
      (WidgetTester tester) async {
    final settings = PrefsSettingsStore();
    final backend =
        await LocalBackendFactory(database: AppDatabase(NativeDatabase.memory()))
            .build();

    await tester.pumpWidget(
      AppBootstrap(
        settings: settings,
        initialBackend: backend,
        ensureBackendReady: (_) async {},
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(AppLogoMark), findsWidgets);

    await backend.dispose();
  });
}
