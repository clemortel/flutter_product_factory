import 'package:flutter/material.dart';

import '../tokens/spacing.dart';

/// A styled card from the Factory design system.
///
/// Wraps [Card] with consistent padding and elevation.
class FactoryCard extends StatelessWidget {
  const FactoryCard({
    required this.child,
    this.onTap,
    this.padding,
    super.key,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final Widget content = Padding(
      padding: padding ??
          const EdgeInsets.all(FactorySpacing.md),
      child: child,
    );

    return Card(
      clipBehavior: Clip.antiAlias,
      child: onTap != null
          ? InkWell(onTap: onTap, child: content)
          : content,
    );
  }
}
