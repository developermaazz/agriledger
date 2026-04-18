import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../app/app_dependencies.dart';
import '../../../app/app_navigator.dart';
import '../../../app/app_router.dart';
import '../../../models/user_profile.dart';
import '../../../services/auth_deep_link_handler.dart';
import '../../../services/settings_repository.dart';
import '../../../shared/l10n/l10n.dart';
import '../../../shared/snackbar/app_snackbar.dart';
import '../../shell/main_shell.dart';
import 'complete_profile_screen.dart';
import 'login_screen.dart';
import 'verify_email_screen.dart';

/// Loads [SettingsRepository.requireEmailLogin] without tying it to [SettingsRepository.revision].
/// Any setting change bumps [revision]; wrapping a [FutureBuilder] in [ValueListenableBuilder]
/// on revision gave a **new** [Future] each rebuild and reset the future to "waiting", which
/// flashed the loading scaffold and login during flows like "remember me" on sign-in.
class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  SettingsRepository? _settings;
  bool? _requireEmailLogin;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final settings = AppDependencies.of(context).settingsRepository;
    if (_settings == null) {
      _settings = settings;
      settings.revision.addListener(_onSettingsRevision);
      unawaited(_loadRequireEmailLogin());
    } else if (!identical(_settings, settings)) {
      _settings!.revision.removeListener(_onSettingsRevision);
      _settings = settings;
      settings.revision.addListener(_onSettingsRevision);
      unawaited(_loadRequireEmailLogin());
    }
  }

  @override
  void dispose() {
    _settings?.revision.removeListener(_onSettingsRevision);
    super.dispose();
  }

  void _onSettingsRevision() {
    unawaited(_loadRequireEmailLogin());
  }

  Future<void> _loadRequireEmailLogin() async {
    final settings = AppDependencies.of(context).settingsRepository;
    final v = await settings.requireEmailLogin;
    if (!mounted) return;
    if (_requireEmailLogin == v) return;
    setState(() => _requireEmailLogin = v);
  }

  @override
  Widget build(BuildContext context) {
    if (_requireEmailLogin == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator.adaptive()),
      );
    }
    return _AuthSession(requireEmailLogin: _requireEmailLogin!);
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
