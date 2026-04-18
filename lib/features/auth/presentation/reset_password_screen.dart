import 'package:flutter/material.dart';

import '../../../app/app_dependencies.dart';
import '../../../domain/auth_validation.dart';
import '../../../shared/auth/auth_error_messages.dart';
import '../../../shared/l10n/l10n.dart';
import '../../../shared/snackbar/app_snackbar.dart';
import 'widgets/auth_page_scaffold.dart';
import 'widgets/password_strength_bar.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key, required this.oobCode});

  final String oobCode;

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _p1 = TextEditingController();
  final _p2 = TextEditingController();
  bool _busy = false;
  bool _obscure1 = true;
  bool _obscure2 = true;

  @override
  void dispose() {
    _p1.dispose();
    _p2.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() != true) return;
    if (!AuthValidation.isPasswordAcceptable(_p1.text)) {
      AppSnackBar.show(
        context,
        message: context.l10n.authPasswordRequirements,
        type: AppSnackType.error,
      );
      return;
    }
    setState(() => _busy = true);
    try {
      await AppDependencies.of(context).authService.confirmPasswordReset(
        code: widget.oobCode,
        newPassword: _p1.text,
      );
      if (!mounted) return;
      AppSnackBar.show(
        context,
        message: context.l10n.authPasswordResetDone,
        type: AppSnackType.success,
      );
      Navigator.of(context).popUntil((r) => r.isFirst);
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
                  context.l10n.authResetPasswordTitle,
                  style: t.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 18),
                TextFormField(
                  controller: _p1,
                  obscureText: _obscure1,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    labelText: context.l10n.authNewPasswordLabel,
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
                PasswordStrengthBar(password: _p1.text),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _p2,
                  obscureText: _obscure2,
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
                    if (v != _p1.text) return context.l10n.authPasswordMismatch;
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
                          context.l10n.authResetSubmit,
                          style: const TextStyle(fontWeight: FontWeight.w700),
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
