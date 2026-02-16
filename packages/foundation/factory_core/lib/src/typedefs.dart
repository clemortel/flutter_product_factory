import 'package:fpdart/fpdart.dart';

import 'failure.dart';

/// A [Future] that resolves to an [Either] of [Failure] or [T].
typedef FutureEither<T> = Future<Either<Failure, T>>;

/// A [Future] that resolves to an [Either] of [Failure] or [Unit].
typedef FutureEitherVoid = Future<Either<Failure, Unit>>;
