import 'package:core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'counter_repository.dart';
import 'counter_state.dart';

part 'counter_notifier.g.dart';

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
@riverpod
class Counter extends _$Counter {
  @override
  Future<CounterState> build() async {
    final CounterRepository repo = ref.read(counterRepositoryProvider);
    final Either<Failure, int> result = await repo.getCount();
    return result.match(
      (failure) => throw failure,
      (value) => CounterState(count: value),
    );
  }

  Future<void> increment() async {
    final CounterState? current = state.valueOrNull;
    if (current == null) return;

    final CounterRepository repo = ref.read(counterRepositoryProvider);
    state = const AsyncLoading();
    final Either<Failure, int> result = await repo.increment(current.count);
    state = result.match(
      (failure) => AsyncError(failure, StackTrace.current),
      (value) => AsyncData(CounterState(count: value)),
    );
  }

  Future<void> decrement() async {
    final CounterState? current = state.valueOrNull;
    if (current == null) return;

    final CounterRepository repo = ref.read(counterRepositoryProvider);
    state = const AsyncLoading();
    final Either<Failure, int> result = await repo.decrement(current.count);
    state = result.match(
      (failure) => AsyncError(failure, StackTrace.current),
      (value) => AsyncData(CounterState(count: value)),
    );
  }

  Future<void> reset() async {
    final CounterRepository repo = ref.read(counterRepositoryProvider);
    state = const AsyncLoading();
    final Either<Failure, int> result = await repo.reset();
    state = result.match(
      (failure) => AsyncError(failure, StackTrace.current),
      (value) => AsyncData(CounterState(count: value)),
    );
  }
}
