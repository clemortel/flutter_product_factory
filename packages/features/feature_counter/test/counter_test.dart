import 'package:factory_async/factory_async.dart';
import 'package:factory_core/factory_core.dart';
import 'package:feature_counter/feature_counter.dart';
import 'package:feature_counter/src/providers/counter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

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

    test('should start with loading then transition to success', () async {
      // The notifier auto-fetches on build.
      // Give the microtask a chance to complete.
      await Future<void>.delayed(Duration.zero);

      final AsyncState<CounterState> state =
          container.read(counterProvider);
      expect(state, isA<AsyncStateSuccess<CounterState>>());
      expect(state.dataOrNull?.count, 0);
    });

    test('should increment the counter', () async {
      await Future<void>.delayed(Duration.zero);
      await container.read(counterProvider.notifier).increment();

      final AsyncState<CounterState> state =
          container.read(counterProvider);
      expect(state.dataOrNull?.count, 1);
    });

    test('should decrement the counter', () async {
      await Future<void>.delayed(Duration.zero);
      await container.read(counterProvider.notifier).increment();
      await container.read(counterProvider.notifier).decrement();

      final AsyncState<CounterState> state =
          container.read(counterProvider);
      expect(state.dataOrNull?.count, 0);
    });

    test('should reset the counter', () async {
      await Future<void>.delayed(Duration.zero);
      await container.read(counterProvider.notifier).increment();
      await container.read(counterProvider.notifier).increment();
      await container.read(counterProvider.notifier).reset();

      final AsyncState<CounterState> state =
          container.read(counterProvider);
      expect(state.dataOrNull?.count, 0);
    });
  });
}
