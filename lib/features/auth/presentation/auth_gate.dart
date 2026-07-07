import 'package:flutter/material.dart';

import '../../../app/app_dependencies.dart';
import '../../../domain/value/auth_user.dart';
import '../../shell/main_shell.dart';
import 'login_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = AppDependencies.of(context).settingsRepository;

    return ValueListenableBuilder<int>(
      valueListenable: settings.revision,
      builder: (context, _, child) {
        return FutureBuilder<bool>(
          future: settings.requireEmailLogin,
          builder: (context, snap) {
            if (!snap.hasData) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator.adaptive()),
              );
            }
            return _AuthSession(requireEmailLogin: snap.data!);
          },
        );
      },
    );
  }
}

class _AuthSession extends StatefulWidget {
  const _AuthSession({required this.requireEmailLogin});

  final bool requireEmailLogin;

  @override
  State<_AuthSession> createState() => _AuthSessionState();
}

class _AuthSessionState extends State<_AuthSession> {
  bool _guestAttempted = false;

  @override
  Widget build(BuildContext context) {
    final auth = AppDependencies.of(context).authService;

    return StreamBuilder<AuthUser?>(
      stream: auth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            snapshot.data == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator.adaptive()),
          );
        }
        if (snapshot.hasError) {
          return Scaffold(body: Center(child: Text(snapshot.error.toString())));
        }

        final user = snapshot.data;
        if (user == null) {
          if (!widget.requireEmailLogin) {
            if (!_guestAttempted) {
              _guestAttempted = true;
              auth.signInAnonymously().then(
                (_) {},
                onError: (_) {
                  if (mounted) {
                    setState(() => _guestAttempted = false);
                  }
                },
              );
            }
            return const Scaffold(
              body: Center(child: CircularProgressIndicator.adaptive()),
            );
          }
          return const LoginScreen();
        }

        _guestAttempted = false;
        return const MainShell();
      },
    );
  }
}
