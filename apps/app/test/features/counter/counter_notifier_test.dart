import 'package:app/features/counter/counter_notifier.dart';
import 'package:app/features/counter/counter_state.dart';
import 'package:app/features/counter/fake_counter_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Counter notifier', () {
    late FakeCounterRepository fakeRepository;
    late ProviderContainer container;

    setUp(() {
      fakeRepository = FakeCounterRepository();
      container = ProviderContainer(
        overrides: [
          counterRepositoryProvider.overrideWithValue(fakeRepository),
        ],
      );
    });

    tearDown(() => container.dispose());

    test('should start in loading state on build', () {
      final AsyncValue<CounterState> state =
          container.read(counterProvider);
      expect(state, isA<AsyncLoading<CounterState>>());
    });

    test('should emit success state after build completes', () async {
      // Wait for the async build to complete.
      await container.read(counterProvider.future);

      final AsyncValue<CounterState> state =
          container.read(counterProvider);
      expect(state, isA<AsyncData<CounterState>>());
      expect(state.valueOrNull?.count, 0);
    });

    test('should increment the counter', () async {
      await container.read(counterProvider.future);
      await container.read(counterProvider.notifier).increment();

      final AsyncValue<CounterState> state =
          container.read(counterProvider);
      expect(state.valueOrNull?.count, 1);
    });

    test('should decrement the counter', () async {
      await container.read(counterProvider.future);
      await container.read(counterProvider.notifier).increment();
      await container.read(counterProvider.notifier).decrement();

      final AsyncValue<CounterState> state =
          container.read(counterProvider);
      expect(state.valueOrNull?.count, 0);
    });

    test('should reset the counter', () async {
      await container.read(counterProvider.future);
      await container.read(counterProvider.notifier).increment();
      await container.read(counterProvider.notifier).increment();
      await container.read(counterProvider.notifier).reset();

      final AsyncValue<CounterState> state =
          container.read(counterProvider);
      expect(state.valueOrNull?.count, 0);
    });
  });
}
