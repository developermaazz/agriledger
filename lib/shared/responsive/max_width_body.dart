import 'package:flutter/widgets.dart';

import 'breakpoints.dart';

/// Centres its child and caps its width so content doesn't stretch edge-to-edge
/// on tablet/desktop. Width passes through unconstrained on phones.
class MaxWidthBody extends StatelessWidget {
  const MaxWidthBody({
    super.key,
    required this.child,
    this.maxWidth = Breakpoints.contentMaxWidth,
  });

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
