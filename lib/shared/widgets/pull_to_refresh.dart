import 'package:flutter/material.dart';

/// Lets [RefreshIndicator] work when the child is shorter than the viewport
/// (empty states, errors, loading).
class MinHeightRefreshContent extends StatelessWidget {
  const MinHeightRefreshContent({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: child,
          ),
        );
      },
    );
  }
}
