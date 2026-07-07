import 'package:flutter/material.dart';

import 'theme/app_tokens.dart';

/// The app's Material 3 theme. Light/dark are built once and cached (they were
/// previously rebuilt every frame). Design tokens live in [AppTokens]; the base
/// [ColorScheme] is seeded green and extended with semantic status roles.
class AppTheme {
  AppTheme._();

  static const Color _seed = Color(0xFF2E7D32);

  static final ThemeData _light = _build(Brightness.light);
  static final ThemeData _dark = _build(Brightness.dark);

  static ThemeData light() => _light;
  static ThemeData dark() => _dark;

  static ThemeData _build(Brightness brightness) {
    final isLight = brightness == Brightness.light;
    final cs = ColorScheme.fromSeed(seedColor: _seed, brightness: brightness);
    final tokens = isLight ? AppTokens.light(cs) : AppTokens.dark(cs);
    final base = ThemeData(useMaterial3: true, colorScheme: cs);

    RoundedRectangleBorder rounded(double r) =>
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(r));

    OutlineInputBorder inputBorder(Color color, [double width = 1]) =>
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(tokens.radiusMd),
          borderSide: BorderSide(color: color, width: width),
        );

    final fieldFill =
        isLight ? cs.surface : cs.surfaceContainerHighest;
    final cardColor = isLight ? cs.surface : cs.surfaceContainerHighest;

    return base.copyWith(
      scaffoldBackgroundColor:
          isLight ? const Color(0xFFF7F8F4) : const Color(0xFF0F1110),
      textTheme: _textTheme(base.textTheme),
      extensions: [tokens],
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: cs.surface,
        foregroundColor: cs.onSurface,
        titleTextStyle: base.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: -0.2,
          color: cs.onSurface,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: cardColor,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(tokens.radiusLg),
          side: BorderSide(color: cs.outlineVariant.withValues(alpha: 0.4)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: fieldFill,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: inputBorder(cs.outlineVariant),
        enabledBorder: inputBorder(cs.outlineVariant),
        focusedBorder: inputBorder(cs.primary, 1.6),
        errorBorder: inputBorder(cs.error),
        focusedErrorBorder: inputBorder(cs.error, 1.6),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          shape: rounded(tokens.radiusMd),
          textStyle: base.textTheme.labelLarge
              ?.copyWith(fontWeight: FontWeight.w700, letterSpacing: 0.2),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          shape: rounded(tokens.radiusMd),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          shape: rounded(tokens.radiusMd),
          side: BorderSide(color: cs.outlineVariant),
          textStyle: base.textTheme.labelLarge
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          textStyle: base.textTheme.labelLarge
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 2,
        highlightElevation: 3,
        shape: rounded(tokens.radiusLg),
      ),
      chipTheme: ChipThemeData(
        shape: StadiumBorder(
          side: BorderSide(color: cs.outlineVariant.withValues(alpha: 0.6)),
        ),
        side: BorderSide(color: cs.outlineVariant.withValues(alpha: 0.6)),
      ),
      dialogTheme: DialogThemeData(
        elevation: 0,
        backgroundColor: cs.surfaceContainerHigh,
        shape: rounded(tokens.radiusXl),
      ),
      dividerTheme: DividerThemeData(
        color: cs.outlineVariant.withValues(alpha: 0.4),
        thickness: 1,
        space: 1,
      ),
      listTileTheme: ListTileThemeData(
        shape: rounded(tokens.radiusMd),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 72,
        backgroundColor: cs.surface,
        elevation: 0,
        indicatorColor:
            cs.primaryContainer.withValues(alpha: isLight ? 0.92 : 0.35),
        indicatorShape: const StadiumBorder(),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            fontSize: 11.5,
            height: 1.1,
            letterSpacing: 0.15,
            fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
            color: selected ? cs.onSurface : cs.onSurfaceVariant,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            size: 24,
            color: selected ? cs.onPrimaryContainer : cs.onSurfaceVariant,
          );
        }),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: cs.surface,
        elevation: 0,
        indicatorColor:
            cs.primaryContainer.withValues(alpha: isLight ? 0.92 : 0.35),
        indicatorShape: const StadiumBorder(),
        selectedIconTheme: IconThemeData(color: cs.onPrimaryContainer),
        unselectedIconTheme: IconThemeData(color: cs.onSurfaceVariant),
        selectedLabelTextStyle: base.textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w800,
          color: cs.onSurface,
        ),
        unselectedLabelTextStyle: base.textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: cs.onSurfaceVariant,
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: SegmentedButton.styleFrom(shape: rounded(tokens.radiusMd)),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: rounded(tokens.radiusMd),
      ),
    );
  }

  /// A refined type scale: tighter tracking on headings, comfortable line
  /// height on body. Uses the platform default font (no bundled font asset).
  static TextTheme _textTheme(TextTheme base) => base.copyWith(
        displaySmall: base.displaySmall
            ?.copyWith(fontWeight: FontWeight.w800, letterSpacing: -0.5),
        headlineMedium: base.headlineMedium?.copyWith(
            fontWeight: FontWeight.w800, letterSpacing: -0.5, height: 1.12),
        headlineSmall: base.headlineSmall
            ?.copyWith(fontWeight: FontWeight.w700, letterSpacing: -0.3),
        titleLarge: base.titleLarge
            ?.copyWith(fontWeight: FontWeight.w700, letterSpacing: -0.2),
        titleMedium: base.titleMedium
            ?.copyWith(fontWeight: FontWeight.w700, letterSpacing: -0.1),
        titleSmall: base.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        bodyLarge: base.bodyLarge?.copyWith(height: 1.4),
        bodyMedium: base.bodyMedium?.copyWith(height: 1.4),
        labelLarge: base.labelLarge
            ?.copyWith(fontWeight: FontWeight.w700, letterSpacing: 0.1),
      );
}
