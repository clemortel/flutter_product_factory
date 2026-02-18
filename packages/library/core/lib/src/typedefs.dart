import 'failure.dart';
import 'result.dart';

/// A [Future] that resolves to a [Result] of [T] or [Failure].
typedef FutureResult<T> = Future<Result<T>>;

/// A [Future] that resolves to a [Result] of [void] or [Failure].
typedef FutureResultVoid = Future<Result<void>>;
