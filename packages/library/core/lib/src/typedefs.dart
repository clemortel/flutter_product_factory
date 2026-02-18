import 'package:fpdart/fpdart.dart';

import 'failure.dart';

/// A [Future] that resolves to an [Either] of [Failure] or [T].
typedef FutureResult<T> = Future<Either<Failure, T>>;

/// A [Future] that resolves to an [Either] of [Failure] or [Unit].
typedef FutureResultVoid = Future<Either<Failure, Unit>>;
