import 'package:factory_ui/factory_ui.dart';
import 'package:flutter/material.dart';

import 'router.dart';

/// Root application widget.
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Factory Demo',
      theme: FactoryTheme.light(),
      darkTheme: FactoryTheme.dark(),
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
