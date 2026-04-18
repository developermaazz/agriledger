import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../app/app_dependencies.dart';
import '../../../shared/auth/auth_error_messages.dart';
import '../../../shared/auth/phone_e164.dart';
import '../../../shared/l10n/l10n.dart';
import '../../../shared/snackbar/app_snackbar.dart';
import 'widgets/auth_page_scaffold.dart';

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _busy = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() != true) return;
    final e164 = tryParseToE164(_phoneController.text);
    if (e164 == null) {
      AppSnackBar.show(
        context,
        message: context.l10n.authPhoneHint,
        type: AppSnackType.error,
      );
      return;
    }
    setState(() => _busy = true);
    final deps = AppDependencies.of(context);
    try {
      final email = deps.authService.currentUser?.email ?? '';
      await deps.userProfileRepository.upsertProfile(
        name: _nameController.text,
        email: email,
        phoneE164: e164,
      );
      if (!mounted) return;
      AppSnackBar.show(
        context,
        message: context.l10n.authProfileSaved,
        type: AppSnackType.success,
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
                  context.l10n.authCompleteProfileTitle,
                  style: t.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                Text(
                  context.l10n.authCompleteProfileSubtitle,
                  style: t.bodyMedium?.copyWith(
                    color: cs.onSurfaceVariant,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 18),
                TextFormField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    labelText: context.l10n.authFullNameLabel,
                    prefixIcon: Icon(Icons.person_outline_rounded, color: cs.primary),
                  ),
                  validator: (v) {
                    if ((v?.trim().length ?? 0) < 2) {
                      return context.l10n.commonRequired;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
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
                          context.l10n.commonSave,
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
