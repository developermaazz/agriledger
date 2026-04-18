import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../app/app_dependencies.dart';
import '../../../app/app_router.dart';
import '../../../shared/auth/auth_error_messages.dart';
import '../../../shared/l10n/l10n.dart';
import '../../../shared/snackbar/app_snackbar.dart';
import 'forgot_password_screen.dart';
import 'signup_screen.dart';
import 'widgets/auth_page_scaffold.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _busy = false;
  bool _obscure = true;
  bool _rememberMe = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadRememberMe());
  }

  Future<void> _loadRememberMe() async {
    if (!mounted) return;
    final v = await AppDependencies.of(context).settingsRepository.authRememberMe;
    if (mounted) setState(() => _rememberMe = v);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _applyRememberMe() async {
    final deps = AppDependencies.of(context);
    await deps.settingsRepository.setAuthRememberMe(_rememberMe);
    await deps.authService.setRememberMe(_rememberMe);
  }

  Future<void> _submit() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;

    setState(() => _busy = true);
    final deps = AppDependencies.of(context);
    final auth = deps.authService;

    try {
      await _applyRememberMe();
      await auth.signInWithEmailPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (!mounted) return;
      final u = auth.currentUser;
      if (u != null && !u.emailVerified) {
        AppSnackBar.show(
          context,
          message: context.l10n.authVerifyEmailRequired,
          type: AppSnackType.info,
        );
      } else {
        AppSnackBar.show(
          context,
          message: context.l10n.authSignedIn,
          type: AppSnackType.success,
        );
      }
    } catch (e) {
      if (!mounted) return;
      AppSnackBar.show(
        context,
        message: messageForAuthException(context, e),
        type: AppSnackType.error,
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;

    return AuthPageScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            child: Text(
              context.l10n.authSubtitleLogin,
              key: ValueKey(context.l10n.authSubtitleLogin),
              textAlign: TextAlign.center,
              style: t.bodyLarge?.copyWith(
                color: cs.onSurfaceVariant,
                height: 1.45,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Material(
            color: cs.surfaceContainerLow,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
              side: BorderSide(color: cs.outlineVariant.withValues(alpha: 0.5)),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.email],
                      decoration: InputDecoration(
                        labelText: context.l10n.authEmailLabel,
                        prefixIcon: Icon(Icons.alternate_email_rounded, color: cs.primary),
                      ),
                      validator: (v) {
                        final s = v?.trim() ?? '';
                        if (s.isEmpty) return context.l10n.commonRequired;
                        if (!s.contains('@')) return context.l10n.authEmailInvalid;
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscure,
                      textInputAction: TextInputAction.done,
                      autofillHints: const [AutofillHints.password],
                      onFieldSubmitted: (_) => _submit(),
                      decoration: InputDecoration(
                        labelText: context.l10n.authPasswordLabel,
                        prefixIcon: Icon(Icons.lock_outline_rounded, color: cs.primary),
                        suffixIcon: IconButton(
                          onPressed: () => setState(() => _obscure = !_obscure),
                          icon: Icon(
                            _obscure
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                      ),
                      validator: (v) {
                        if ((v ?? '').isEmpty) return context.l10n.commonRequired;
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: _busy
                            ? null
                            : () {
                                Navigator.of(context, rootNavigator: true).push<void>(
                                  MaterialPageRoute<void>(
                                    settings: const RouteSettings(
                                      name: AppRoutes.forgotPassword,
                                    ),
                                    builder: (_) => const ForgotPasswordScreen(),
                                  ),
                                );
                              },
                        child: Text(context.l10n.authForgotPassword),
                      ),
                    ),
                    if (kIsWeb) ...[
                      CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        value: _rememberMe,
                        onChanged: _busy
                            ? null
                            : (v) => setState(() => _rememberMe = v ?? true),
                        title: Text(context.l10n.authRememberMe),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    ],
                    const SizedBox(height: 8),
                    FilledButton(
                      onPressed: _busy ? null : _submit,
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(54),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: _busy
                          ? SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator.adaptive(
                                strokeWidth: 2.5,
                                valueColor: AlwaysStoppedAnimation<Color>(cs.onPrimary),
                              ),
                            )
                          : Text(
                              context.l10n.authSignIn,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.2,
                              ),
                            ),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: _busy
                          ? null
                          : () async {
                              final nav = Navigator.of(context, rootNavigator: true);
                              final email = await nav.push<String?>(
                                MaterialPageRoute<String?>(
                                  settings: const RouteSettings(name: AppRoutes.signup),
                                  builder: (_) => const SignupScreen(),
                                ),
                              );
                              if (!context.mounted) return;
                              if (email != null && email.isNotEmpty) {
                                setState(() => _emailController.text = email);
                                AppSnackBar.show(
                                  context,
                                  message: context.l10n.authPrefilledEmailHint,
                                  type: AppSnackType.info,
                                );
                              }
                            },
                      child: Text(
                        context.l10n.authNewHere,
                        style: t.labelLarge?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
