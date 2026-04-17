import 'package:flutter/material.dart';

import '../l10n/l10n.dart';

class FirestoreErrorView extends StatelessWidget {
  const FirestoreErrorView({
    super.key,
    required this.error,
    this.title,
  });

  final Object error;
  final String? title;

  @override
  Widget build(BuildContext context) {
    final msg = error.toString();
    final isPermissionDenied = msg.contains('permission-denied') ||
        msg.contains('PERMISSION_DENIED') ||
        msg.contains('Missing or insufficient permissions');

    final effectiveTitle = title ?? context.l10n.errorsSomethingWentWrong;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isPermissionDenied ? Icons.lock_outline : Icons.error_outline,
              size: 56,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 12),
            Text(
              effectiveTitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              isPermissionDenied
                  ? context.l10n.errorsFirestoreBlocked
                  : msg,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            if (!isPermissionDenied) ...[
              const SizedBox(height: 10),
              Text(
                msg,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

