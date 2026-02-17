import 'failure.dart';

/// A simple, dependency-free Result type following
/// [Flutter's official architecture pattern](https://docs.flutter.dev/app-architecture/design-patterns/result).
///
/// Use pattern matching for exhaustive handling:
/// ```dart
/// switch (result) {
///   Success(:final value) => handleSuccess(value),
///   Err(:final failure) => handleError(failure),
/// }
/// ```
sealed class Result<T> {
  const Result();
}

final class Success<T> extends Result<T> {
  const Success(this.value);

  final T value;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Success<T> && other.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'Success($value)';
}

final class Err<T> extends Result<T> {
  const Err(this.failure);

  final Failure failure;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Err<T> && other.failure == failure;

  @override
  int get hashCode => failure.hashCode;

  @override
  String toString() => 'Err($failure)';
}
