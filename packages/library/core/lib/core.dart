/// Core utilities for Flutter Product Factory.
///
/// Provides the [Failure] sealed class, fpdart [Either] re-exports,
/// [Talker] logging, environment configuration, and common type aliases.
library core;

export 'package:fpdart/fpdart.dart' show Either, Left, Right, Unit, unit;
export 'package:talker/talker.dart' show Talker, TalkerLog, LogLevel;

export 'src/env_config.dart';
export 'src/failure.dart';
export 'src/typedefs.dart';
