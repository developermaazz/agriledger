import 'package:flutter/material.dart';

import '../l10n/l10n.dart';

/// Custom mark: rounded tile, leaf + ledger strokes (agriculture + accounts).
class AppLogoMark extends StatelessWidget {
  const AppLogoMark({
    super.key,
    this.size = 88,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final s = size;

    return Semantics(
      label: context.l10n.appTitle,
      child: Container(
        width: s,
        height: s,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(s * 0.26),
          boxShadow: [
            BoxShadow(
              color: cs.primary.withValues(alpha: 0.22),
              blurRadius: s * 0.28,
              offset: Offset(0, s * 0.09),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(s * 0.26),
          child: CustomPaint(
            size: Size(s, s),
            painter: _AgriLedgerMarkPainter(
              primary: cs.primary,
              primaryContainer: cs.primaryContainer,
              onPrimary: cs.onPrimary,
            ),
          ),
        ),
      ),
    );
  }
}

class _AgriLedgerMarkPainter extends CustomPainter {
  _AgriLedgerMarkPainter({
    required this.primary,
    required this.primaryContainer,
    required this.onPrimary,
  });

  final Color primary;
  final Color primaryContainer;
  final Color onPrimary;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final bg = Rect.fromLTWH(0, 0, w, h);
    final gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color.lerp(primary, primaryContainer, 0.35)!,
        primary,
      ],
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(bg, Radius.circular(w * 0.26)),
      Paint()..shader = gradient.createShader(bg),
    );

    // Subtle inner highlight (premium gloss)
    final gloss = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.08, h * 0.08, w * 0.84, h * 0.42),
      Radius.circular(w * 0.12),
    );
    canvas.drawRRect(
      gloss,
      Paint()
        ..color = onPrimary.withValues(alpha: 0.12)
        ..style = PaintingStyle.fill,
    );

    // Leaf (growth / agriculture)
    final leaf = Path()
      ..moveTo(w * 0.32, h * 0.72)
      ..quadraticBezierTo(w * 0.18, h * 0.48, w * 0.38, h * 0.22)
      ..quadraticBezierTo(w * 0.58, h * 0.28, w * 0.52, h * 0.52)
      ..quadraticBezierTo(w * 0.46, h * 0.68, w * 0.32, h * 0.72)
      ..close();
    canvas.drawPath(
      leaf,
      Paint()
        ..color = onPrimary.withValues(alpha: 0.95)
        ..style = PaintingStyle.fill,
    );
    canvas.drawPath(
      Path()
        ..moveTo(w * 0.4, h * 0.38)
        ..quadraticBezierTo(w * 0.36, h * 0.52, w * 0.38, h * 0.62),
      Paint()
        ..color = primary.withValues(alpha: 0.35)
        ..style = PaintingStyle.stroke
        ..strokeWidth = w * 0.018
        ..strokeCap = StrokeCap.round,
    );

    // Ledger lines (right side — bookkeeping)
    final linePaint = Paint()
      ..color = onPrimary.withValues(alpha: 0.88)
      ..strokeWidth = w * 0.022
      ..strokeCap = StrokeCap.round;
    final x0 = w * 0.58;
    final x1 = w * 0.88;
    for (var i = 0; i < 4; i++) {
      final y = h * (0.34 + i * 0.11);
      canvas.drawLine(Offset(x0, y), Offset(x1, y), linePaint);
    }
    // Spine
    canvas.drawLine(
      Offset(w * 0.54, h * 0.28),
      Offset(w * 0.54, h * 0.78),
      Paint()
        ..color = onPrimary.withValues(alpha: 0.45)
        ..strokeWidth = w * 0.02
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant _AgriLedgerMarkPainter oldDelegate) {
    return oldDelegate.primary != primary ||
        oldDelegate.primaryContainer != primaryContainer ||
        oldDelegate.onPrimary != onPrimary;
  }
}

/// Two-tone wordmark: first word in primary, second word emphasized on surface.
class AppBrandTitle extends StatelessWidget {
  const AppBrandTitle({
    super.key,
    this.textStyle,
  });

  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;
    final base = textStyle ??
        t.headlineMedium?.copyWith(
          fontWeight: FontWeight.w800,
          letterSpacing: -0.8,
          height: 1.05,
        );

    final w1 = context.l10n.appTitleWord1;
    final w2 = context.l10n.appTitleWord2;

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: w1,
            style: base?.copyWith(
              color: cs.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
          TextSpan(
            text: ' ',
            style: base,
          ),
          TextSpan(
            text: w2,
            style: base?.copyWith(
              color: cs.onSurface,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
      textAlign: TextAlign.center,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}
