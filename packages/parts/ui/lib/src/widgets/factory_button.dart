import 'package:flutter/material.dart';

import '../tokens/spacing.dart';

/// A styled button from the Factory design system.
///
/// Wraps [FilledButton] with consistent padding and sizing.
class FactoryButton extends StatelessWidget {
  const FactoryButton({
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final Widget child = isLoading
        ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : Text(label);

    if (icon != null && !isLoading) {
      return FilledButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: child,
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: FactorySpacing.lg,
            vertical: FactorySpacing.md,
          ),
        ),
      );
    }

    return FilledButton(
      onPressed: isLoading ? null : onPressed,
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: FactorySpacing.lg,
          vertical: FactorySpacing.md,
        ),
      ),
      child: child,
    );
  }
}
