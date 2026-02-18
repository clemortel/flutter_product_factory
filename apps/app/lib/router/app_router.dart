import 'package:auto_route/auto_route.dart';

import '../features/counter/counter_page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: CounterRoute.page, initial: true),
      ];
}
