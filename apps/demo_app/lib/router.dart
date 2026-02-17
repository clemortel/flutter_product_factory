import 'package:feature_counter/feature_counter.dart';
import 'package:go_router/go_router.dart';

/// Application router configuration.
final GoRouter appRouter = GoRouter(
  initialLocation: '/counter',
  routes: [
    counterRoute,
  ],
);
