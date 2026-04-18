import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app/app.dart';
import 'firebase_options.dart';
import 'services/auth_deep_link_handler.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final deepLinkHandler = AuthDeepLinkHandler();
  final appLinks = AppLinks();

  Future<void> handleUri(Uri? uri) async {
    if (uri == null) return;
    await deepLinkHandler.handleUri(uri);
  }

  unawaited(handleUri(await appLinks.getInitialLink()));
  appLinks.uriLinkStream.listen(handleUri);

  runApp(MyApp(authDeepLinkHandler: deepLinkHandler));
}
