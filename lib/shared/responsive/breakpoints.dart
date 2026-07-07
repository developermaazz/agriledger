import 'package:flutter/widgets.dart';

/// Material 3 window size classes.
enum WindowSize { compact, medium, expanded }

class Breakpoints {
  Breakpoints._();

  /// Tablet / small landscape.
  static const double medium = 600;

  /// Desktop / large landscape.
  static const double expanded = 1024;

  /// Comfortable max content width for forms and detail views.
  static const double formMaxWidth = 640;

  /// Comfortable max content width for lists and dashboards.
  static const double contentMaxWidth = 1100;
}

extension ResponsiveContext on BuildContext {
  WindowSize get windowSize {
    final width = MediaQuery.sizeOf(this).width;
    if (width >= Breakpoints.expanded) return WindowSize.expanded;
    if (width >= Breakpoints.medium) return WindowSize.medium;
    return WindowSize.compact;
  }

  bool get isCompact => windowSize == WindowSize.compact;
  bool get isMedium => windowSize == WindowSize.medium;
  bool get isExpanded => windowSize == WindowSize.expanded;
}
