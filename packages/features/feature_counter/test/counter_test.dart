import 'package:factory_async/factory_async.dart';
import 'package:factory_core/factory_core.dart';
import 'package:feature_counter/feature_counter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

void main() {
  provideDummy<Either<Failure, int>>(const Right(0));

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
      final AsyncState<CounterState> state =
          container.read(counterProvider);
      expect(state, isA<AsyncStateLoading<CounterState>>());
    });

    test('should emit success state after refresh', () async {
      // Use refresh() which is awaitable.
      await container.read(counterProvider.notifier).refresh();

      final AsyncState<CounterState> state =
          container.read(counterProvider);
      expect(state, isA<AsyncStateSuccess<CounterState>>());
      expect(state.dataOrNull?.count, 0);
    });

    test('should increment the counter', () async {
      await container.read(counterProvider.notifier).refresh();
      await container.read(counterProvider.notifier).increment();

      final AsyncState<CounterState> state =
          container.read(counterProvider);
      expect(state.dataOrNull?.count, 1);
    });

    test('should decrement the counter', () async {
      await container.read(counterProvider.notifier).refresh();
      await container.read(counterProvider.notifier).increment();
      await container.read(counterProvider.notifier).decrement();

      final AsyncState<CounterState> state =
          container.read(counterProvider);
      expect(state.dataOrNull?.count, 0);
    });

    test('should reset the counter', () async {
      await container.read(counterProvider.notifier).refresh();
      await container.read(counterProvider.notifier).increment();
      await container.read(counterProvider.notifier).increment();
      await container.read(counterProvider.notifier).reset();

      final AsyncState<CounterState> state =
          container.read(counterProvider);
      expect(state.dataOrNull?.count, 0);
    });
  });
}
