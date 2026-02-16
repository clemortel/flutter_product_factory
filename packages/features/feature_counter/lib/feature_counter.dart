/// Counter domain feature.
///
/// Provides [CounterState], [CounterRepository], and a Riverpod
/// notifier that exposes `counterProvider`.
library feature_counter;

export 'src/models/counter_state.dart';
export 'src/providers/counter.dart';
export 'src/repositories/counter_repository.dart';
export 'src/repositories/fake_counter_repository.dart';
