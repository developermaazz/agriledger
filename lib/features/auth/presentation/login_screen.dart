import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../app/app_dependencies.dart';
import '../../../shared/l10n/l10n.dart';
import '../../../shared/snackbar/app_snackbar.dart';
import '../../../shared/widgets/app_brand.dart';
import '../../../shared/widgets/developer_credit_footer.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isRegisterMode = false;
  bool _isBusy = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }

    setState(() => _isBusy = true);
    final auth = AppDependencies.of(context).authService;

    try {
      if (_isRegisterMode) {
        await auth.registerWithEmailPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
      } else {
        await auth.signInWithEmailPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
      }

      if (!mounted) {
        return;
      }
      AppSnackBar.show(
        context,
        message: _isRegisterMode
            ? context.l10n.authAccountCreated
            : context.l10n.authSignedIn,
        type: AppSnackType.success,
      );
    } on FirebaseAuthException catch (e) {
      AppSnackBar.show(
        context,
        message: e.message ?? context.l10n.authFailed,
        type: AppSnackType.error,
      );
    } catch (e) {
      AppSnackBar.show(
        context,
        message: e.toString(),
        type: AppSnackType.error,
      );
    } finally {
      if (mounted) {
        setState(() => _isBusy = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;

    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomCenter,
            colors: [
              cs.primaryContainer.withValues(alpha: 0.55),
              cs.surface,
              cs.surface,
            ],
            stops: const [0.0, 0.38, 1.0],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 12),
                    const Center(
                      child: AppLogoMark(size: 92),
                    ),
                    const SizedBox(height: 22),
                    const AppBrandTitle(),
                    const SizedBox(height: 10),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 220),
                      child: Text(
                        _isRegisterMode
                            ? context.l10n.authSubtitleRegister
                            : context.l10n.authSubtitleLogin,
                        key: ValueKey(_isRegisterMode),
                        textAlign: TextAlign.center,
                        style: t.bodyLarge?.copyWith(
                          color: cs.onSurfaceVariant,
                          height: 1.45,
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    Material(
                      color: cs.surfaceContainerLow,
                      elevation: 0,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                        side: BorderSide(
                          color: cs.outlineVariant.withValues(alpha: 0.5),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: cs.primaryContainer
                                          .withValues(alpha: 0.65),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      _isRegisterMode
                                          ? context.l10n.authCreateAccount
                                          : context.l10n.authSignIn,
                                      style: t.labelLarge?.copyWith(
                                        color: cs.onPrimaryContainer,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 18),
                              TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                autofillHints: const [
                                  AutofillHints.email,
                                ],
                                decoration: InputDecoration(
                                  labelText: context.l10n.authEmailLabel,
                                  prefixIcon: Icon(
                                    Icons.alternate_email_rounded,
                                    color: cs.primary,
                                  ),
                                ),
                                validator: (value) {
                                  final v = value?.trim() ?? '';
                                  if (v.isEmpty) {
                                    return context.l10n.authEmailRequired;
                                  }
                                  if (!v.contains('@')) {
                                    return context.l10n.authEmailInvalid;
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 14),
                              TextFormField(
                                controller: _passwordController,
                                obscureText: _obscurePassword,
                                textInputAction: TextInputAction.done,
                                autofillHints: _isRegisterMode
                                    ? const [AutofillHints.newPassword]
                                    : const [AutofillHints.password],
                                onFieldSubmitted: (_) => _submit(),
                                decoration: InputDecoration(
                                  labelText: context.l10n.authPasswordLabel,
                                  prefixIcon: Icon(
                                    Icons.lock_outline_rounded,
                                    color: cs.primary,
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                      color: cs.onSurfaceVariant,
                                    ),
                                  ),
                                ),
                                validator: (value) {
                                  final v = value ?? '';
                                  if (v.length < 6) {
                                    return context.l10n.authPasswordTooShort;
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 22),
                              FilledButton(
                                onPressed: _isBusy ? null : _submit,
                                style: FilledButton.styleFrom(
                                  minimumSize: const Size.fromHeight(54),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                child: _isBusy
                                    ? SizedBox(
                                        height: 22,
                                        width: 22,
                                        child: CircularProgressIndicator.adaptive(
                                          strokeWidth: 2.5,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            cs.onPrimary,
                                          ),
                                        ),
                                      )
                                    : Text(
                                        _isRegisterMode
                                            ? context.l10n.authCreateAccount
                                            : context.l10n.authSignIn,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 0.2,
                                        ),
                                      ),
                              ),
                              const SizedBox(height: 8),
                              TextButton(
                                onPressed: _isBusy
                                    ? null
                                    : () {
                                        setState(() {
                                          _isRegisterMode = !_isRegisterMode;
                                        });
                                      },
                                child: Text(
                                  _isRegisterMode
                                      ? context.l10n.authAlreadyHaveAccount
                                      : context.l10n.authNewHere,
                                  style: t.labelLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const DeveloperCreditFooter(compact: true),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
