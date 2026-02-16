import 'package:go_router/go_router.dart';

import 'counter_page.dart';

/// go_router route for the counter feature.
final GoRoute counterRoute = GoRoute(
  path: '/counter',
  name: 'counter',
  builder: (context, state) => const CounterPage(),
);
