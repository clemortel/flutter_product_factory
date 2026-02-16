import 'dart:io';

import 'package:path/path.dart' as p;

/// Generates a new part package scaffold.
abstract final class PartTemplate {
  static void generate({
    required String partName,
    required String featureName,
    required String outputPath,
  }) {
    final String pkg = '${partName}_part';
    final String featurePkg = 'feature_$featureName';
    final String pascal = _snakeToPascal(partName);

    _writeFile(p.join(outputPath, 'pubspec.yaml'), _pubspec(pkg, featurePkg));
    _writeFile(p.join(outputPath, 'lib', '$pkg.dart'), _barrel(pkg, partName));
    _writeFile(
      p.join(outputPath, 'lib', 'src', '${partName}_page.dart'),
      _page(pascal, featurePkg),
    );
    _writeFile(
      p.join(outputPath, 'lib', 'src', '${partName}_route.dart'),
      _route(pascal, partName),
    );
  }

  static void _writeFile(String path, String content) {
    final File file = File(path);
    file.parent.createSync(recursive: true);
    file.writeAsStringSync(content);
  }

  static String _pubspec(String pkg, String featurePkg) => '''
name: $pkg
description: UI composition for the $featurePkg feature.
version: 0.1.0
publish_to: none

environment:
  sdk: ^3.8.0
  flutter: ">=3.8.0"

resolution: workspace

dependencies:
  factory_async:
  factory_ui:
  $featurePkg:
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.6.1
  go_router: ^14.0.0
''';

  static String _barrel(String pkg, String name) => '''
library $pkg;

export 'src/${name}_page.dart';
export 'src/${name}_route.dart';
''';

  static String _page(String pascal, String featurePkg) => '''
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ${pascal}Page extends ConsumerWidget {
  const ${pascal}Page({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('$pascal')),
      body: const Center(
        child: Text('$pascal page — replace with your UI'),
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

  static String _snakeToPascal(String snake) {
    return snake
        .split('_')
        .map((w) => w.isEmpty ? '' : '${w[0].toUpperCase()}${w.substring(1)}')
        .join();
  }

  static String _lowerFirst(String s) =>
      s.isEmpty ? s : '${s[0].toLowerCase()}${s.substring(1)}';
}
