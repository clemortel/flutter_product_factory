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
    _writeFile(
      p.join(outputPath, 'lib', 'router', 'app_router.dart'),
      _router(),
    );
    _writeFile(p.join(outputPath, 'lib', 'env', 'env.dart'), _env());
    _writeFile(p.join(outputPath, '.env'), _dotEnv());
    _writeFile(p.join(outputPath, '.env.example'), _dotEnv());
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
  auto_route: ^9.3.0
  core:
  envied: ^1.1.1
  http_client:
  ui:
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.6.1
  freezed_annotation: ^3.0.0
  riverpod_annotation: ^2.6.1

dev_dependencies:
  auto_route_generator: ^9.3.0
  build_runner: ^2.4.0
  envied_generator: ^1.1.1
  flutter_test:
    sdk: flutter
  freezed: ^3.0.0
  riverpod_generator: ^2.6.3
''';

  static String _main(String name) => '''
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'env/env.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final EnvConfig envConfig = EnvConfig(
    apiBaseUrl: Env.apiBaseUrl,
    environment: Env.environment,
  );

  final Talker talker = Talker();
  talker.info('Starting app in \${envConfig.environment} mode');

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
import 'package:flutter/material.dart';
import 'package:ui/ui.dart';

import 'router/app_router.dart';

class App extends StatelessWidget {
  App({super.key});

  final AppRouter _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: '$title',
      theme: FactoryTheme.light(),
      darkTheme: FactoryTheme.dark(),
      routerConfig: _appRouter.config(),
      debugShowCheckedModeBanner: false,
    );
  }
}
''';
  }

  static String _router() => '''
import 'package:auto_route/auto_route.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        // Add routes here
      ];
}
''';

  static String _env() => '''
import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'API_BASE_URL')
  static const String apiBaseUrl = _Env.apiBaseUrl;

  @EnviedField(varName: 'ENVIRONMENT', defaultValue: 'development')
  static const String environment = _Env.environment;
}
''';

  static String _dotEnv() => '''
API_BASE_URL=https://api-dev.example.com
ENVIRONMENT=development
''';

  static String _test(String name) => '''
import 'package:$name/app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App renders without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
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
