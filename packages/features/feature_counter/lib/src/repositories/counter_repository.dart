import 'package:factory_core/factory_core.dart';

/// Contract for counter persistence.
abstract interface class CounterRepository {
  FutureEither<int> getCount();
  FutureEither<int> increment(int currentCount);
  FutureEither<int> decrement(int currentCount);
  FutureEither<int> reset();
}
