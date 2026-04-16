import 'package:flutter/material.dart';

class AsyncBody extends StatelessWidget {
  const AsyncBody({
    super.key,
    required this.snapshot,
    required this.onData,
    this.onLoading,
    this.emptyMessage = 'Nothing here yet',
  });

  final AsyncSnapshot<dynamic> snapshot;
  final Widget Function(BuildContext context, dynamic data) onData;
  final Widget? onLoading;
  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return onLoading ??
          const Center(child: CircularProgressIndicator.adaptive());
    }
    if (snapshot.hasError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            snapshot.error.toString(),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    final data = snapshot.data;
    if (data == null) {
      return Center(child: Text(emptyMessage));
    }
    return onData(context, data);
  }
}
