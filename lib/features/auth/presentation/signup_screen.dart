import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../app/app_dependencies.dart';
import '../../../domain/auth_validation.dart';
import '../../../shared/auth/auth_error_messages.dart';
import '../../../shared/auth/phone_e164.dart';
import '../../../shared/l10n/l10n.dart';
import '../../../shared/snackbar/app_snackbar.dart';
import 'widgets/auth_page_scaffold.dart';
import 'widgets/password_strength_bar.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _busy = false;
  bool _obscure1 = true;
  bool _obscure2 = true;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;

    final e164 = tryParseToE164(_phoneController.text);
    if (e164 == null) {
      AppSnackBar.show(
        context,
        message: context.l10n.authPhoneHint,
        type: AppSnackType.error,
      );
      return;
    }

    if (!AuthValidation.isPasswordAcceptable(_passwordController.text)) {
      AppSnackBar.show(
        context,
        message: context.l10n.authPasswordRequirements,
        type: AppSnackType.error,
      );
      return;
    }

    setState(() => _busy = true);
    final deps = AppDependencies.of(context);
    final auth = deps.authService;
    final profiles = deps.userProfileRepository;

    try {
      await auth.registerWithEmailPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      await profiles.upsertProfile(
        name: _nameController.text,
        email: _emailController.text,
        phoneE164: e164,
      );
      await auth.sendEmailVerification();
      if (!mounted) return;
      AppSnackBar.show(
        context,
        message: context.l10n.authAccountCreated,
        type: AppSnackType.success,
      );
      // Pop back to the AuthGate so it can show VerifyEmailScreen.
      Navigator.of(context).popUntil((r) => r.isFirst);
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      if (e.code == 'email-already-in-use') {
        await _showAccountAlreadyExistsDialog();
        return;
      }
      AppSnackBar.show(
        context,
        message: messageForAuthException(context, e),
        type: AppSnackType.error,
      );
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

  Future<void> _showAccountAlreadyExistsDialog() async {
    final email = _emailController.text.trim();
    final go = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        final l10n = context.l10n;
        return AlertDialog(
          title: Text(l10n.authAccountAlreadyExistsTitle),
          content: SingleChildScrollView(
            child: Text(l10n.authAccountAlreadyExistsMessage),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(l10n.commonCancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(l10n.authGoToSignInFromSignup),
            ),
          ],
        );
      },
    );
    if (go == true && mounted) {
      Navigator.of(context).pop<String>(email);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;

    return AuthPageScaffold(
      leading: IconButton(
        tooltip: MaterialLocalizations.of(context).backButtonTooltip,
        onPressed: _busy ? null : () => Navigator.of(context).maybePop(),
        icon: const Icon(Icons.arrow_back_rounded),
      ),
      child: Material(
        color: cs.surfaceContainerLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: BorderSide(color: cs.outlineVariant.withValues(alpha: 0.5)),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  context.l10n.authSignupTitle,
                  style: t.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 6),
                Text(
                  context.l10n.authSubtitleRegister,
                  style: t.bodyMedium?.copyWith(
                    color: cs.onSurfaceVariant,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 18),
                TextFormField(
                  controller: _nameController,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    labelText: context.l10n.authFullNameLabel,
                    prefixIcon: Icon(Icons.person_outline_rounded, color: cs.primary),
                  ),
                  validator: (v) {
                    final s = v?.trim() ?? '';
                    if (s.length < 2) return context.l10n.commonRequired;
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[\d+\s\-()]+')),
                  ],
                  decoration: InputDecoration(
                    labelText: context.l10n.authPhoneLabel,
                    hintText: context.l10n.authPhoneHint,
                    prefixIcon: Icon(Icons.phone_iphone_rounded, color: cs.primary),
                  ),
                  validator: (v) {
                    if (tryParseToE164(v ?? '') == null) {
                      return context.l10n.commonInvalid;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
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
                    if (!AuthValidation.isValidEmail(s)) {
                      return context.l10n.authEmailInvalid;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscure1,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.newPassword],
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    labelText: context.l10n.authPasswordLabel,
                    prefixIcon: Icon(Icons.lock_outline_rounded, color: cs.primary),
                    suffixIcon: IconButton(
                      onPressed: () => setState(() => _obscure1 = !_obscure1),
                      icon: Icon(
                        _obscure1 ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ),
                  validator: (v) {
                    if (!AuthValidation.isPasswordAcceptable(v ?? '')) {
                      return context.l10n.authPasswordRequirements;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                PasswordStrengthBar(password: _passwordController.text),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _confirmController,
                  obscureText: _obscure2,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _submit(),
                  decoration: InputDecoration(
                    labelText: context.l10n.authConfirmPasswordLabel,
                    prefixIcon: Icon(Icons.lock_person_outlined, color: cs.primary),
                    suffixIcon: IconButton(
                      onPressed: () => setState(() => _obscure2 = !_obscure2),
                      icon: Icon(
                        _obscure2 ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ),
                  validator: (v) {
                    if (v != _passwordController.text) {
                      return context.l10n.authPasswordMismatch;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 22),
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
                          context.l10n.authCreateAccount,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.2,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
