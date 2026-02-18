import 'package:flutter/material.dart';

import '../tokens/colors.dart';

/// Creates the Factory design system [ThemeData].
///
/// ```dart
/// MaterialApp(
///   theme: FactoryTheme.light(),
///   darkTheme: FactoryTheme.dark(),
/// )
/// ```
abstract final class FactoryTheme {
  static ThemeData light() => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: FactoryColors.primary,
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(centerTitle: true),
      );

  static ThemeData dark() => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: FactoryColors.primary,
          brightness: Brightness.dark,
        ),
        appBarTheme: const AppBarTheme(centerTitle: true),
      );
}
