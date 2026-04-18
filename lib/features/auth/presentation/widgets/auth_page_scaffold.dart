import 'package:flutter/material.dart';

import '../../../../shared/widgets/app_brand.dart';
import '../../../../shared/widgets/developer_credit_footer.dart';

/// Shared gradient + centered card layout for auth flows.
class AuthPageScaffold extends StatelessWidget {
  const AuthPageScaffold({
    super.key,
    required this.child,
    this.leading,
    this.maxWidth = 440,
  });

  final Widget child;
  final Widget? leading;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

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
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (leading != null) ...[
                      Align(alignment: Alignment.centerLeft, child: leading),
                      const SizedBox(height: 8),
                    ],
                    const SizedBox(height: 8),
                    const Center(child: AppLogoMark(size: 72)),
                    const SizedBox(height: 16),
                    const AppBrandTitle(),
                    const SizedBox(height: 20),
                    child,
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
