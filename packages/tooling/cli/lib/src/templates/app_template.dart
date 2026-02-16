import 'dart:io';

import 'package:path/path.dart' as p;

/// Generates a new Flutter app scaffold.
abstract final class AppTemplate {
  static void generate({
    required String appName,
    required String outputPath,
  }) {
    _writeFile(p.join(outputPath, 'pubspec.yaml'), _pubspec(appName));
    _writeFile(p.join(outputPath, 'lib', 'main.dart'), _main(appName));
    _writeFile(p.join(outputPath, 'lib', 'app.dart'), _app(appName));
    _writeFile(p.join(outputPath, 'lib', 'router.dart'), _router());
    _writeFile(p.join(outputPath, 'test', 'app_test.dart'), _test(appName));
  }

  static void _writeFile(String path, String content) {
    final File file = File(path);
    file.parent.createSync(recursive: true);
    file.writeAsStringSync(content);
  }

  static String _pubspec(String name) => '''
name: $name
description: A Flutter app built with Flutter Product Factory.
version: 0.1.0
publish_to: none

environment:
  sdk: ^3.8.0
  flutter: ">=3.8.0"

resolution: workspace

dependencies:
  factory_ui:
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.6.1
  go_router: ^14.0.0

dev_dependencies:
  flutter_test:
    sdk: flutter
''';

  static String _main(String name) => '''
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}
''';

  static String _app(String name) {
    final String title = _snakeToTitle(name);
    return '''
import 'package:factory_ui/factory_ui.dart';
import 'package:flutter/material.dart';

import 'router.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: '$title',
      theme: FactoryTheme.light(),
      darkTheme: FactoryTheme.dark(),
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
''';
  }

  static String _router() => '''
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const Placeholder(),
    ),
  ],
);
''';

  static String _test(String name) => '''
import 'package:$name/app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App renders without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: App(),
      ),
    );
    await tester.pumpAndSettle();
  });
}
''';

  static String _snakeToTitle(String snake) {
    return snake
        .split('_')
        .map((w) => w.isEmpty ? '' : '${w[0].toUpperCase()}${w.substring(1)}')
        .join(' ');
  }
}
