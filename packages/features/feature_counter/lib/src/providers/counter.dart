import 'package:factory_async/factory_async.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/counter_state.dart';
import '../repositories/counter_repository.dart';

part 'counter.g.dart';

/// Provider for the [CounterRepository] instance.
///
/// Override this in your app to supply the real or fake implementation.
@Riverpod(keepAlive: true)
CounterRepository counterRepository(CounterRepositoryRef ref) {
  throw UnimplementedError(
    'counterRepositoryProvider must be overridden with a concrete implementation.',
  );
}

/// Counter notifier that manages [AsyncState]<[CounterState]>.
///
/// Generates `counterProvider` (not `counterNotifierProvider`).
@riverpod
class Counter extends _$Counter {
  @override
  AsyncState<CounterState> build() {
    _fetch();
    return const AsyncState.loading();
  }

  Future<void> _fetch() async {
    final CounterRepository repo = ref.read(counterRepositoryProvider);
    final result = await repo.getCount();
    result.fold(
      (failure) => state = AsyncState.error(failure),
      (count) => state = AsyncState.success(CounterState(count: count)),
    );
  }

  Future<void> increment() async {
    final CounterState? current = state.dataOrNull;
    if (current == null) return;

    final CounterRepository repo = ref.read(counterRepositoryProvider);
    final result = await repo.increment(current.count);
    result.fold(
      (failure) => state = AsyncState.error(failure),
      (count) => state = AsyncState.success(CounterState(count: count)),
    );
  }

  Future<void> decrement() async {
    final CounterState? current = state.dataOrNull;
    if (current == null) return;

    final CounterRepository repo = ref.read(counterRepositoryProvider);
    final result = await repo.decrement(current.count);
    result.fold(
      (failure) => state = AsyncState.error(failure),
      (count) => state = AsyncState.success(CounterState(count: count)),
    );
  }

  Future<void> reset() async {
    final CounterRepository repo = ref.read(counterRepositoryProvider);
    final result = await repo.reset();
    result.fold(
      (failure) => state = AsyncState.error(failure),
      (count) => state = AsyncState.success(CounterState(count: count)),
    );
  }
}
