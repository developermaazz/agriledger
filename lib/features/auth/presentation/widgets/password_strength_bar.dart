import 'package:flutter/material.dart';

import '../../../../domain/auth_validation.dart';
import '../../../../l10n/app_localizations.dart';

class PasswordStrengthBar extends StatelessWidget {
  const PasswordStrengthBar({super.key, required this.password});

  final String password;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final s = AuthValidation.assessPassword(password);
    final cs = Theme.of(context).colorScheme;
    final label = switch (s.fraction) {
      < 0.35 => l10n.authPasswordStrengthWeak,
      < 0.55 => l10n.authPasswordStrengthFair,
      < 0.8 => l10n.authPasswordStrengthGood,
      _ => l10n.authPasswordStrengthStrong,
    };
    final color = switch (s.fraction) {
      < 0.35 => cs.error,
      < 0.55 => cs.tertiary,
      < 0.8 => cs.primary,
      _ => cs.primary,
    };

    return Semantics(
      label: '${l10n.authPasswordLabel}: $label',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: s.fraction.clamp(0.0, 1.0),
              minHeight: 6,
              backgroundColor: cs.surfaceContainerHighest,
              color: color,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: cs.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}
