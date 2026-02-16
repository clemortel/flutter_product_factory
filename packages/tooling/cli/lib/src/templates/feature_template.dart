import 'dart:io';

import 'package:path/path.dart' as p;

/// Generates a new feature package scaffold.
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
description: $pkg domain feature.
version: 0.1.0
publish_to: none

environment:
  sdk: ^3.8.0
  flutter: ">=3.8.0"

resolution: workspace

dependencies:
  factory_async:
  factory_core:
  factory_platform_interface:
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.6.1
  freezed_annotation: ^3.0.0
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
  FutureEither<Unit> fetch();
}
''';

  static String _fakeRepository(String pascal, String name) => '''
import 'package:factory_core/factory_core.dart';

import '${name}_repository.dart';

class Fake${pascal}Repository implements ${pascal}Repository {
  @override
  FutureEither<Unit> fetch() async => const Right(unit);
}
''';

  static String _provider(String pascal, String name) => '''
import 'package:factory_async/factory_async.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/${name}_state.dart';
import '../repositories/${name}_repository.dart';

part '$name.g.dart';

@Riverpod(keepAlive: true)
${pascal}Repository ${_lowerFirst(pascal)}Repository(${pascal}RepositoryRef ref) {
  throw UnimplementedError(
    '${_lowerFirst(pascal)}RepositoryProvider must be overridden.',
  );
}

@riverpod
class $pascal extends _\$$pascal {
  @override
  AsyncState<${pascal}State> build() {
    _fetch();
    return const AsyncState.loading();
  }

  Future<void> _fetch() async {
    final repo = ref.read(${_lowerFirst(pascal)}RepositoryProvider);
    final result = await repo.fetch();
    result.fold(
      (failure) => state = AsyncState.error(failure),
      (_) => state = const AsyncState.success(${pascal}State()),
    );
  }

  Future<void> refresh() async {
    state = const AsyncState.loading();
    await _fetch();
  }
}
''';

  static String _test(String pkg, String pascal, String name) => '''
import 'package:factory_async/factory_async.dart';
import 'package:factory_core/factory_core.dart';
import 'package:$pkg/$pkg.dart';
import 'package:$pkg/src/providers/$name.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  provideDummy<Either<Failure, Unit>>(const Right(unit));

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

    test('should transition to success after fetch', () async {
      await Future<void>.delayed(Duration.zero);
      final state = container.read(${_lowerFirst(pascal)}Provider);
      expect(state, isA<AsyncStateSuccess<${pascal}State>>());
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
