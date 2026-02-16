/// Sealed class representing all possible failure types.
///
/// Use pattern matching for exhaustive handling:
/// ```dart
/// switch (failure) {
///   NetworkFailure(:final message) => ...,
///   ServerFailure(:final message, :final statusCode) => ...,
///   ...
/// }
/// ```
sealed class Failure {
  const Failure(this.message);

  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

final class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

final class ServerFailure extends Failure {
  const ServerFailure(super.message, {this.statusCode});

  final int? statusCode;
}

final class NotFoundFailure extends Failure {
  const NotFoundFailure(super.message);
}

final class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure(super.message);
}

final class ValidationFailure extends Failure {
  const ValidationFailure(super.message, {this.errors});

  final Map<String, List<String>>? errors;
}

final class UnknownFailure extends Failure {
  const UnknownFailure(super.message);
}
