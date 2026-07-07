import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// Design tokens exposed as a [ThemeExtension]: spacing, radii, semantic status
/// colors (which the base [ColorScheme] lacks), and the brand gradient. Read via
/// `AppTokens.of(context)`.
@immutable
class AppTokens extends ThemeExtension<AppTokens> {
  const AppTokens({
    required this.spaceXs,
    required this.spaceSm,
    required this.spaceMd,
    required this.spaceLg,
    required this.spaceXl,
    required this.spaceXxl,
    required this.radiusSm,
    required this.radiusMd,
    required this.radiusLg,
    required this.radiusXl,
    required this.success,
    required this.onSuccessContainer,
    required this.successContainer,
    required this.warning,
    required this.onWarningContainer,
    required this.warningContainer,
    required this.danger,
    required this.onDangerContainer,
    required this.dangerContainer,
    required this.info,
    required this.onInfoContainer,
    required this.infoContainer,
    required this.brandGradient,
  });

  // Spacing scale (constant across themes).
  final double spaceXs; // 4
  final double spaceSm; // 8
  final double spaceMd; // 12
  final double spaceLg; // 16
  final double spaceXl; // 24
  final double spaceXxl; // 32

  // Corner radii.
  final double radiusSm; // 12
  final double radiusMd; // 14
  final double radiusLg; // 18
  final double radiusXl; // 24

  // Semantic status colors (theme-aware; missing from ColorScheme).
  final Color success;
  final Color onSuccessContainer;
  final Color successContainer;
  final Color warning;
  final Color onWarningContainer;
  final Color warningContainer;
  final Color danger;
  final Color onDangerContainer;
  final Color dangerContainer;
  final Color info;
  final Color onInfoContainer;
  final Color infoContainer;

  final Gradient brandGradient;

  static AppTokens of(BuildContext context) =>
      Theme.of(context).extension<AppTokens>()!;

  static const double _xs = 4, _sm = 8, _md = 12, _lg = 16, _xl = 24, _xxl = 32;
  static const double _rSm = 12, _rMd = 14, _rLg = 18, _rXl = 24;

  factory AppTokens.light(ColorScheme scheme) => AppTokens(
        spaceXs: _xs,
        spaceSm: _sm,
        spaceMd: _md,
        spaceLg: _lg,
        spaceXl: _xl,
        spaceXxl: _xxl,
        radiusSm: _rSm,
        radiusMd: _rMd,
        radiusLg: _rLg,
        radiusXl: _rXl,
        success: const Color(0xFF2E7D32),
        successContainer: const Color(0xFFC8EBCB),
        onSuccessContainer: const Color(0xFF0C3311),
        warning: const Color(0xFFB26A00),
        warningContainer: const Color(0xFFFFE2B5),
        onWarningContainer: const Color(0xFF3F2A00),
        danger: const Color(0xFFB3261E),
        dangerContainer: const Color(0xFFF9DEDC),
        onDangerContainer: const Color(0xFF410E0B),
        info: const Color(0xFF1565C0),
        infoContainer: const Color(0xFFD6E3FB),
        onInfoContainer: const Color(0xFF0A2A54),
        brandGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [scheme.primary, scheme.primaryContainer],
        ),
      );

  factory AppTokens.dark(ColorScheme scheme) => AppTokens(
        spaceXs: _xs,
        spaceSm: _sm,
        spaceMd: _md,
        spaceLg: _lg,
        spaceXl: _xl,
        spaceXxl: _xxl,
        radiusSm: _rSm,
        radiusMd: _rMd,
        radiusLg: _rLg,
        radiusXl: _rXl,
        success: const Color(0xFF88D992),
        successContainer: const Color(0xFF1C4A24),
        onSuccessContainer: const Color(0xFFC8EBCB),
        warning: const Color(0xFFF2B85A),
        warningContainer: const Color(0xFF4A3200),
        onWarningContainer: const Color(0xFFFFE2B5),
        danger: const Color(0xFFF2B8B5),
        dangerContainer: const Color(0xFF5C1712),
        onDangerContainer: const Color(0xFFF9DEDC),
        info: const Color(0xFF9EC3FA),
        infoContainer: const Color(0xFF0C2E58),
        onInfoContainer: const Color(0xFFD6E3FB),
        brandGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [scheme.primary, scheme.primaryContainer],
        ),
      );

  @override
  AppTokens copyWith({
    double? spaceXs,
    double? spaceSm,
    double? spaceMd,
    double? spaceLg,
    double? spaceXl,
    double? spaceXxl,
    double? radiusSm,
    double? radiusMd,
    double? radiusLg,
    double? radiusXl,
    Color? success,
    Color? onSuccessContainer,
    Color? successContainer,
    Color? warning,
    Color? onWarningContainer,
    Color? warningContainer,
    Color? danger,
    Color? onDangerContainer,
    Color? dangerContainer,
    Color? info,
    Color? onInfoContainer,
    Color? infoContainer,
    Gradient? brandGradient,
  }) {
    return AppTokens(
      spaceXs: spaceXs ?? this.spaceXs,
      spaceSm: spaceSm ?? this.spaceSm,
      spaceMd: spaceMd ?? this.spaceMd,
      spaceLg: spaceLg ?? this.spaceLg,
      spaceXl: spaceXl ?? this.spaceXl,
      spaceXxl: spaceXxl ?? this.spaceXxl,
      radiusSm: radiusSm ?? this.radiusSm,
      radiusMd: radiusMd ?? this.radiusMd,
      radiusLg: radiusLg ?? this.radiusLg,
      radiusXl: radiusXl ?? this.radiusXl,
      success: success ?? this.success,
      onSuccessContainer: onSuccessContainer ?? this.onSuccessContainer,
      successContainer: successContainer ?? this.successContainer,
      warning: warning ?? this.warning,
      onWarningContainer: onWarningContainer ?? this.onWarningContainer,
      warningContainer: warningContainer ?? this.warningContainer,
      danger: danger ?? this.danger,
      onDangerContainer: onDangerContainer ?? this.onDangerContainer,
      dangerContainer: dangerContainer ?? this.dangerContainer,
      info: info ?? this.info,
      onInfoContainer: onInfoContainer ?? this.onInfoContainer,
      infoContainer: infoContainer ?? this.infoContainer,
      brandGradient: brandGradient ?? this.brandGradient,
    );
  }

  @override
  AppTokens lerp(ThemeExtension<AppTokens>? other, double t) {
    if (other is! AppTokens) return this;
    Color c(Color a, Color b) => Color.lerp(a, b, t)!;
    double d(double a, double b) => lerpDouble(a, b, t)!;
    return AppTokens(
      spaceXs: d(spaceXs, other.spaceXs),
      spaceSm: d(spaceSm, other.spaceSm),
      spaceMd: d(spaceMd, other.spaceMd),
      spaceLg: d(spaceLg, other.spaceLg),
      spaceXl: d(spaceXl, other.spaceXl),
      spaceXxl: d(spaceXxl, other.spaceXxl),
      radiusSm: d(radiusSm, other.radiusSm),
      radiusMd: d(radiusMd, other.radiusMd),
      radiusLg: d(radiusLg, other.radiusLg),
      radiusXl: d(radiusXl, other.radiusXl),
      success: c(success, other.success),
      onSuccessContainer: c(onSuccessContainer, other.onSuccessContainer),
      successContainer: c(successContainer, other.successContainer),
      warning: c(warning, other.warning),
      onWarningContainer: c(onWarningContainer, other.onWarningContainer),
      warningContainer: c(warningContainer, other.warningContainer),
      danger: c(danger, other.danger),
      onDangerContainer: c(onDangerContainer, other.onDangerContainer),
      dangerContainer: c(dangerContainer, other.dangerContainer),
      info: c(info, other.info),
      onInfoContainer: c(onInfoContainer, other.onInfoContainer),
      infoContainer: c(infoContainer, other.infoContainer),
      brandGradient: Gradient.lerp(brandGradient, other.brandGradient, t)!,
    );
  }
}
