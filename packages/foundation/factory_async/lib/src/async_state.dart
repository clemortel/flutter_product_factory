import 'package:factory_core/factory_core.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'async_state.freezed.dart';

/// A type-safe wrapper for asynchronous operation states.
///
/// ```dart
/// return switch (state) {
///   AsyncStateIdle() || AsyncStateLoading() => const CircularProgressIndicator(),
///   AsyncStateSuccess(:final data) => DataView(data: data),
///   AsyncStateError(:final failure) => ErrorView(failure: failure),
/// };
/// ```
@Freezed(genericArgumentFactories: true)
sealed class AsyncState<T> with _$AsyncState<T> {
  const factory AsyncState.idle() = AsyncStateIdle<T>;
  const factory AsyncState.loading() = AsyncStateLoading<T>;
  const factory AsyncState.success(T data) = AsyncStateSuccess<T>;
  const factory AsyncState.error(Failure failure) = AsyncStateError<T>;

  const AsyncState._();

  bool get isIdle => this is AsyncStateIdle<T>;
  bool get isLoading => this is AsyncStateLoading<T>;
  bool get isSuccess => this is AsyncStateSuccess<T>;
  bool get isError => this is AsyncStateError<T>;

  /// Returns the data if in success state, otherwise null.
  T? get dataOrNull => switch (this) {
    AsyncStateSuccess(:final data) => data,
    _ => null,
  };

  /// Returns the failure if in error state, otherwise null.
  Failure? get failureOrNull => switch (this) {
    AsyncStateError(:final failure) => failure,
    _ => null,
  };
}
