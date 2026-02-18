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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NetworkFailure && other.message == message;

  @override
  int get hashCode => message.hashCode;
}

final class ServerFailure extends Failure {
  const ServerFailure(super.message, {this.statusCode});

  final int? statusCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServerFailure &&
          other.message == message &&
          other.statusCode == statusCode;

  @override
  int get hashCode => Object.hash(message, statusCode);
}

final class NotFoundFailure extends Failure {
  const NotFoundFailure(super.message);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotFoundFailure && other.message == message;

  @override
  int get hashCode => message.hashCode;
}

final class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure(super.message);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UnauthorizedFailure && other.message == message;

  @override
  int get hashCode => message.hashCode;
}

final class ValidationFailure extends Failure {
  const ValidationFailure(super.message, {this.errors});

  final Map<String, List<String>>? errors;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ValidationFailure &&
          other.message == message &&
          other.errors == errors;

  @override
  int get hashCode => Object.hash(message, errors);
}

final class UnknownFailure extends Failure {
  const UnknownFailure(super.message);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UnknownFailure && other.message == message;

  @override
  int get hashCode => message.hashCode;
}
