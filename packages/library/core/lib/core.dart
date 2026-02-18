/// Core utilities for Flutter Product Factory.
///
/// Provides the [Failure] sealed class, fpdart [Either] re-exports,
/// logging, environment configuration, and common type aliases.
library core;

export 'package:fpdart/fpdart.dart' show Either, Left, Right, Unit, unit;

export 'src/env_config.dart';
export 'src/failure.dart';
export 'src/logging/logger.dart';
export 'src/logging/print_logger.dart';
export 'src/typedefs.dart';
