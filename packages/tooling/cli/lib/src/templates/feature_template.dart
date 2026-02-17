import 'dart:io';

import 'package:path/path.dart' as p;

/// Generates a new co-located feature package scaffold.
///
/// Each feature contains domain logic (models, repositories, providers)
/// and presentation (page, route) in a single package.
abstract final class FeatureTemplate {
  static void generate({
    required String featureName,
    required String outputPath,
  }) {
    final String pkg = 'feature_$featureName';
    final String pascal = _snakeToPascal(featureName);

    _writeFile(p.join(outputPath, 'pubspec.yaml'), _pubspec(pkg));
    _writeFile(p.join(outputPath, 'lib', '$pkg.dart'), _barrel(pkg, featureName));
    _writeFile(
      p.join(outputPath, 'lib', 'src', 'models', '${featureName}_state.dart'),
      _model(pascal),
    );
    _writeFile(
      p.join(outputPath, 'lib', 'src', 'repositories', '${featureName}_repository.dart'),
      _repository(pascal),
    );
    _writeFile(
      p.join(outputPath, 'lib', 'src', 'repositories', 'fake_${featureName}_repository.dart'),
      _fakeRepository(pascal, featureName),
    );
    _writeFile(
      p.join(outputPath, 'lib', 'src', 'providers', '$featureName.dart'),
      _provider(pascal, featureName),
    );
    _writeFile(
      p.join(outputPath, 'lib', 'src', 'presentation', '${featureName}_page.dart'),
      _page(pascal, featureName),
    );
    _writeFile(
      p.join(outputPath, 'lib', 'src', 'presentation', '${featureName}_route.dart'),
      _route(pascal, featureName),
    );
    _writeFile(
      p.join(outputPath, 'test', '${featureName}_test.dart'),
      _test(pkg, pascal, featureName),
    );
  }

  static void _writeFile(String path, String content) {
    final File file = File(path);
    file.parent.createSync(recursive: true);
    file.writeAsStringSync(content);
  }

  static String _pubspec(String pkg) => '''
name: $pkg
description: $pkg feature — domain logic and UI, co-located.
version: 0.1.0
publish_to: none

environment:
  sdk: ^3.8.0
  flutter: ">=3.8.0"

resolution: workspace

dependencies:
  factory_core:
  factory_ui:
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.6.1
  freezed_annotation: ^3.0.0
  go_router: ^14.0.0
  riverpod_annotation: ^2.6.1

dev_dependencies:
  build_runner: ^2.4.0
  flutter_test:
    sdk: flutter
  freezed: ^3.0.0
  mockito: ^5.4.0
  riverpod_generator: ^2.6.3
''';

  static String _barrel(String pkg, String name) => '''
library $pkg;

export 'src/models/${name}_state.dart';
export 'src/presentation/${name}_page.dart';
export 'src/presentation/${name}_route.dart';
export 'src/providers/$name.dart';
export 'src/repositories/${name}_repository.dart';
export 'src/repositories/fake_${name}_repository.dart';
''';

  static String _model(String pascal) => '''
import 'package:freezed_annotation/freezed_annotation.dart';

part '${_pascalToSnake(pascal)}_state.freezed.dart';

@freezed
abstract class ${pascal}State with _\$${pascal}State {
  const factory ${pascal}State() = _${pascal}State;
}
''';

  static String _repository(String pascal) => '''
import 'package:factory_core/factory_core.dart';

abstract interface class ${pascal}Repository {
  FutureResultVoid fetch();
}
''';

  static String _fakeRepository(String pascal, String name) => '''
import 'package:factory_core/factory_core.dart';

import '${name}_repository.dart';

class Fake${pascal}Repository implements ${pascal}Repository {
  @override
  FutureResultVoid fetch() async => const Success(null);
}
''';

  static String _provider(String pascal, String name) => '''
import 'package:factory_core/factory_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/${name}_state.dart';
import '../repositories/${name}_repository.dart';

part '$name.g.dart';

@Riverpod(keepAlive: true)
${pascal}Repository ${_lowerFirst(pascal)}Repository(Ref ref) {
  throw UnimplementedError(
    '${_lowerFirst(pascal)}RepositoryProvider must be overridden.',
  );
}

@riverpod
class $pascal extends _\$$pascal {
  @override
  Future<${pascal}State> build() async {
    final repo = ref.read(${_lowerFirst(pascal)}RepositoryProvider);
    final Result<void> result = await repo.fetch();
    return switch (result) {
      Success() => const ${pascal}State(),
      Err(:final failure) => throw FailureException(failure),
    };
  }
}

/// Wraps a [Failure] as an [Exception] for [AsyncValue.guard].
class FailureException implements Exception {
  const FailureException(this.failure);
  final Failure failure;

  @override
  String toString() => failure.toString();
}
''';

  static String _page(String pascal, String featureName) => '''
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/${featureName}_state.dart';
import '../providers/$featureName.dart';

class ${pascal}Page extends ConsumerWidget {
  const ${pascal}Page({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<${pascal}State> asyncState =
        ref.watch(${_lowerFirst(pascal)}Provider);

    return Scaffold(
      appBar: AppBar(title: const Text('$pascal')),
      body: Center(
        child: asyncState.when(
          loading: () => const CircularProgressIndicator(),
          data: (${pascal}State data) =>
              const Text('$pascal page — replace with your UI'),
          error: (Object error, _) => Text('Error: \$error'),
        ),
      ),
    );
  }
}
''';

  static String _route(String pascal, String name) => '''
import 'package:go_router/go_router.dart';

import '${name}_page.dart';

final GoRoute ${_lowerFirst(pascal)}Route = GoRoute(
  path: '/$name',
  name: '$name',
  builder: (context, state) => const ${pascal}Page(),
);
''';

  static String _test(String pkg, String pascal, String name) => '''
import 'package:$pkg/$pkg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('$pascal notifier', () {
    late Fake${pascal}Repository fakeRepository;
    late ProviderContainer container;

    setUp(() {
      fakeRepository = Fake${pascal}Repository();
      container = ProviderContainer(
        overrides: [
          ${_lowerFirst(pascal)}RepositoryProvider.overrideWithValue(fakeRepository),
        ],
      );
    });

    tearDown(() => container.dispose());

    test('should transition to success after build', () async {
      await container.read(${_lowerFirst(pascal)}Provider.future);
      final state = container.read(${_lowerFirst(pascal)}Provider);
      expect(state, isA<AsyncData<${pascal}State>>());
    });
  });
}
''';

  static String _snakeToPascal(String snake) {
    return snake
        .split('_')
        .map((w) => w.isEmpty ? '' : '${w[0].toUpperCase()}${w.substring(1)}')
        .join();
  }

  static String _pascalToSnake(String pascal) {
    return pascal
        .replaceAllMapped(RegExp('([A-Z])'), (m) => '_${m[1]!.toLowerCase()}')
        .substring(1);
  }

  static String _lowerFirst(String s) =>
      s.isEmpty ? s : '${s[0].toLowerCase()}${s.substring(1)}';
}
