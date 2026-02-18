import 'dart:io';

import 'package:path/path.dart' as p;

/// Generates a new feature scaffold as flat files inside an app.
///
/// Features are no longer separate packages — they live directly
/// in `lib/features/<name>/` within the app.
abstract final class FeatureTemplate {
  static void generate({
    required String featureName,
    required String outputPath,
    required String testOutputPath,
  }) {
    final String pascal = _snakeToPascal(featureName);

    _writeFile(
      p.join(outputPath, '${featureName}_state.dart'),
      _model(pascal),
    );
    _writeFile(
      p.join(outputPath, '${featureName}_repository.dart'),
      _repository(pascal),
    );
    _writeFile(
      p.join(outputPath, 'fake_${featureName}_repository.dart'),
      _fakeRepository(pascal, featureName),
    );
    _writeFile(
      p.join(outputPath, '${featureName}_notifier.dart'),
      _notifier(pascal, featureName),
    );
    _writeFile(
      p.join(outputPath, '${featureName}_page.dart'),
      _page(pascal, featureName),
    );
    _writeFile(
      p.join(testOutputPath, '${featureName}_notifier_test.dart'),
      _test(pascal, featureName),
    );
  }

  static void _writeFile(String path, String content) {
    final File file = File(path);
    file.parent.createSync(recursive: true);
    file.writeAsStringSync(content);
  }

  static String _model(String pascal) => '''
import 'package:freezed_annotation/freezed_annotation.dart';

part '${_pascalToSnake(pascal)}_state.freezed.dart';

@freezed
abstract class ${pascal}State with _\$${pascal}State {
  const factory ${pascal}State() = _${pascal}State;
}
''';

  static String _repository(String pascal) => '''
import 'package:core/core.dart';

abstract interface class ${pascal}Repository {
  FutureResultVoid fetch();
}
''';

  static String _fakeRepository(String pascal, String name) => '''
import 'package:core/core.dart';

import '${name}_repository.dart';

class Fake${pascal}Repository implements ${pascal}Repository {
  @override
  FutureResultVoid fetch() async => Right(unit);
}
''';

  static String _notifier(String pascal, String name) => '''
import 'package:core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '${name}_repository.dart';
import '${name}_state.dart';

part '${name}_notifier.g.dart';

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
    final result = await repo.fetch();
    return result.match(
      (failure) => throw failure,
      (_) => const ${pascal}State(),
    );
  }
}
''';

  static String _page(String pascal, String featureName) => '''
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '${featureName}_notifier.dart';
import '${featureName}_state.dart';

@RoutePage()
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

  static String _test(String pascal, String name) => '''
import 'package:app/features/$name/${name}_notifier.dart';
import 'package:app/features/$name/${name}_state.dart';
import 'package:app/features/$name/fake_${name}_repository.dart';
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
