import 'package:core/core.dart';

import 'counter_repository.dart';

/// In-memory [CounterRepository] for demos and testing.
class FakeCounterRepository implements CounterRepository {
  int _count = 0;

  @override
  FutureResult<int> getCount() async => Right(_count);

  @override
  FutureResult<int> increment(int currentCount) async {
    _count = currentCount + 1;
    return Right(_count);
  }

  @override
  FutureResult<int> decrement(int currentCount) async {
    _count = currentCount - 1;
    return Right(_count);
  }

  @override
  FutureResult<int> reset() async {
    _count = 0;
    return Right(_count);
  }
}
