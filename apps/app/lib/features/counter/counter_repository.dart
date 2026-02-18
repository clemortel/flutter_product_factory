import 'package:core/core.dart';

/// Contract for counter persistence.
abstract interface class CounterRepository {
  FutureResult<int> getCount();
  FutureResult<int> increment(int currentCount);
  FutureResult<int> decrement(int currentCount);
  FutureResult<int> reset();
}
