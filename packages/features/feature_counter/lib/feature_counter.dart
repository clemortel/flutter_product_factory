/// Counter feature — domain logic and UI, co-located.
///
/// Provides [CounterState], [CounterRepository], a Riverpod notifier
/// (`counterProvider`), and the [CounterPage] with its route.
library feature_counter;

export 'src/models/counter_state.dart';
export 'src/presentation/counter_page.dart';
export 'src/presentation/counter_route.dart';
export 'src/providers/counter.dart';
export 'src/repositories/counter_repository.dart';
export 'src/repositories/fake_counter_repository.dart';
