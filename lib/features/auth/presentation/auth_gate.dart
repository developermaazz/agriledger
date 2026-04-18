import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../app/app_dependencies.dart';
import '../../../app/app_navigator.dart';
import '../../../app/app_router.dart';
import '../../../models/user_profile.dart';
import '../../../services/auth_deep_link_handler.dart';
import '../../../shared/l10n/l10n.dart';
import '../../../shared/snackbar/app_snackbar.dart';
import '../../shell/main_shell.dart';
import 'complete_profile_screen.dart';
import 'login_screen.dart';
import 'verify_email_screen.dart';

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
  AuthDeepLinkHandler? _deepLinkHandler;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _attachDeepLink());
  }

  void _attachDeepLink() {
    if (!mounted) return;
    _deepLinkHandler = AppDependencies.of(context).authDeepLinkHandler;
    _deepLinkHandler!.pending.addListener(_onDeepLink);
    _onDeepLink();
  }

  @override
  void dispose() {
    _deepLinkHandler?.pending.removeListener(_onDeepLink);
    super.dispose();
  }

  void _onDeepLink() {
    final handler = AppDependencies.of(context).authDeepLinkHandler;
    final p = handler.pending.value;
    if (p == null) return;
    if (p.kind == PendingAuthKind.resetPassword && (p.oobCode ?? '').isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        appNavigatorKey.currentState?.pushNamed(
          AppRoutes.resetPassword,
          arguments: p.oobCode,
        );
        handler.clear();
      });
      return;
    }
    if (p.kind == PendingAuthKind.emailVerifiedFromLink) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        AppSnackBar.show(
          context,
          message: context.l10n.authEmailVerifiedFromLinkSnack,
          type: AppSnackType.success,
        );
        handler.clear();
      });
      return;
    }
    if (p.kind == PendingAuthKind.linkError) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        AppSnackBar.show(
          context,
          message: p.message ?? context.l10n.authFailed,
          type: AppSnackType.error,
        );
        handler.clear();
      });
    }
  }

  bool _profileComplete(UserProfile? p) {
    if (p == null) return false;
    return p.name.trim().isNotEmpty && p.phoneE164.trim().isNotEmpty;
  }

  bool _isVerified(User user, UserProfile? p) {
    if (user.isAnonymous) return true;
    return user.emailVerified || (p?.isVerified == true);
  }

  @override
  Widget build(BuildContext context) {
    final auth = AppDependencies.of(context).authService;
    final profileRepo = AppDependencies.of(context).userProfileRepository;

    return StreamBuilder<User?>(
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

        if (user.isAnonymous) {
          return const MainShell();
        }

        return StreamBuilder<UserProfile?>(
          stream: profileRepo.profileStream(),
          builder: (context, profSnap) {
            if (profSnap.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator.adaptive()),
              );
            }
            final profile = profSnap.data;
            if (!_profileComplete(profile)) {
              return const CompleteProfileScreen();
            }
            if (!_isVerified(user, profile)) {
              return const VerifyEmailScreen();
            }
            return const MainShell();
          },
        );
      },
    );
  }
}
