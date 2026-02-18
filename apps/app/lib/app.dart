import 'package:flutter/material.dart';
import 'package:ui/ui.dart';

import 'router/app_router.dart';

/// Root application widget.
class App extends StatelessWidget {
  App({super.key});

  final AppRouter _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Factory Demo',
      theme: FactoryTheme.light(),
      darkTheme: FactoryTheme.dark(),
      routerConfig: _appRouter.config(),
      debugShowCheckedModeBanner: false,
    );
  }
}
