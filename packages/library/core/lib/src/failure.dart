import 'package:freezed_annotation/freezed_annotation.dart';

part 'failure.freezed.dart';

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
@freezed
sealed class Failure with _$Failure {
  const factory Failure.network(String message) = NetworkFailure;
  const factory Failure.server(String message, {int? statusCode}) =
      ServerFailure;
  const factory Failure.notFound(String message) = NotFoundFailure;
  const factory Failure.unauthorized(String message) = UnauthorizedFailure;
  const factory Failure.validation(
    String message, {
    Map<String, List<String>>? errors,
  }) = ValidationFailure;
  const factory Failure.unknown(String message) = UnknownFailure;
}
