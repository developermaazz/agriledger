import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n/l10n.dart';
import '../snackbar/app_snackbar.dart';

/// Portfolio / profile site (HTTPS).
const String kDeveloperProfileUrl = 'https://developermaaz.etslogisticsllc.com/';

Future<void> openDeveloperProfile(BuildContext context) async {
  final uri = Uri.parse(kDeveloperProfileUrl);
  try {
    var launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched) {
      launched = await launchUrl(uri, mode: LaunchMode.platformDefault);
    }
    if (!launched && context.mounted) {
      AppSnackBar.show(
        context,
        message: context.l10n.creditsLinkCouldNotOpen,
        type: AppSnackType.error,
      );
    }
  } catch (_) {
    if (context.mounted) {
      AppSnackBar.show(
        context,
        message: context.l10n.creditsLinkCouldNotOpen,
        type: AppSnackType.error,
      );
    }
  }
}

/// Developer attribution — author name opens the portfolio in the browser.
class DeveloperCreditFooter extends StatelessWidget {
  const DeveloperCreditFooter({
    super.key,
    this.compact = false,
  });

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;
    final introStyle = (compact ? t.labelMedium : t.labelLarge)?.copyWith(
      color: cs.onSurfaceVariant.withValues(alpha: 0.88),
      fontWeight: FontWeight.w600,
      letterSpacing: compact ? 0.4 : 0.5,
      fontStyle: FontStyle.italic,
    );
    final bodyStyle = (compact ? t.bodySmall : t.bodyMedium)?.copyWith(
      color: cs.onSurfaceVariant,
      height: 1.45,
      fontWeight: FontWeight.w500,
    );
    final nameStyle = bodyStyle?.copyWith(
      color: cs.primary,
      fontWeight: FontWeight.w800,
      decoration: TextDecoration.underline,
      decorationColor: cs.primary,
      decorationThickness: 1.2,
    );

    final prefix = context.l10n.creditsAttributionPrefix;
    final name = context.l10n.creditsAuthorName;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (!compact) ...[
          Divider(
            height: 1,
            color: cs.outlineVariant.withValues(alpha: 0.45),
          ),
          const SizedBox(height: 20),
        ] else
          const SizedBox(height: 8),
        Text(
          context.l10n.creditsIntro,
          textAlign: TextAlign.center,
          style: introStyle,
        ),
        SizedBox(height: compact ? 6 : 8),
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(prefix, style: bodyStyle, textAlign: TextAlign.center),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Semantics(
                button: true,
                label: name,
                hint: context.l10n.creditsAuthorLinkA11yHint,
                child: GestureDetector(
                  onTap: () => openDeveloperProfile(context),
                  child: Text(name, style: nameStyle),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
