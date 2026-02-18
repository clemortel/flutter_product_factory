import 'package:flutter/material.dart';

/// A styled text field from the Factory design system.
///
/// Wraps [TextField] with consistent decoration.
class FactoryTextField extends StatelessWidget {
  const FactoryTextField({
    this.controller,
    this.label,
    this.hint,
    this.errorText,
    this.obscureText = false,
    this.onChanged,
    this.keyboardType,
    super.key,
  });

  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final String? errorText;
  final bool obscureText;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      onChanged: onChanged,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        errorText: errorText,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
