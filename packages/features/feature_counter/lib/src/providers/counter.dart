import 'package:factory_core/factory_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/counter_state.dart';
import '../repositories/counter_repository.dart';

part 'counter.g.dart';

/// Provider for the [CounterRepository] instance.
///
/// Override this in your app to supply the real or fake implementation.
@Riverpod(keepAlive: true)
CounterRepository counterRepository(Ref ref) {
  throw UnimplementedError(
    'counterRepositoryProvider must be overridden with a concrete implementation.',
  );
}

/// Counter notifier that manages [AsyncValue]<[CounterState]>.
///
/// Uses Riverpod's native [AsyncValue] for state management,
/// with [AsyncValue.guard] for clean error handling.
@riverpod
class Counter extends _$Counter {
  @override
  Future<CounterState> build() async {
    final CounterRepository repo = ref.read(counterRepositoryProvider);
    final Result<int> result = await repo.getCount();
    return switch (result) {
      Success(:final value) => CounterState(count: value),
      Err(:final failure) => throw FailureException(failure),
    };
  }

  Future<void> increment() async {
    final CounterState? current = state.valueOrNull;
    if (current == null) return;

    final CounterRepository repo = ref.read(counterRepositoryProvider);
    state = await AsyncValue.guard(() async {
      final Result<int> result = await repo.increment(current.count);
      return switch (result) {
        Success(:final value) => CounterState(count: value),
        Err(:final failure) => throw FailureException(failure),
      };
    });
  }

  Future<void> decrement() async {
    final CounterState? current = state.valueOrNull;
    if (current == null) return;

    final CounterRepository repo = ref.read(counterRepositoryProvider);
    state = await AsyncValue.guard(() async {
      final Result<int> result = await repo.decrement(current.count);
      return switch (result) {
        Success(:final value) => CounterState(count: value),
        Err(:final failure) => throw FailureException(failure),
      };
    });
  }

  Future<void> reset() async {
    final CounterRepository repo = ref.read(counterRepositoryProvider);
    state = await AsyncValue.guard(() async {
      final Result<int> result = await repo.reset();
      return switch (result) {
        Success(:final value) => CounterState(count: value),
        Err(:final failure) => throw FailureException(failure),
      };
    });
  }
}

/// Wraps a [Failure] as an [Exception] so it can be thrown into
/// [AsyncValue.guard] and recovered in the UI via [AsyncError].
class FailureException implements Exception {
  const FailureException(this.failure);

  final Failure failure;

  @override
  String toString() => failure.toString();
}
