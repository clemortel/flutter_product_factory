/// Core utilities for Flutter Product Factory.
///
/// Provides the [Failure] sealed class, fpdart re-exports, and common
/// type aliases used across all packages.
library factory_core;

export 'package:fpdart/fpdart.dart' show Either, Left, Right, Option, Unit, unit;

export 'src/failure.dart';
export 'src/typedefs.dart';
