import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:path/path.dart' as p;

import '../templates/feature_template.dart';

/// Scaffolds a new feature inside the app.
class AddFeatureCommand extends Command<void> {
  AddFeatureCommand() {
    argParser.addOption(
      'name',
      abbr: 'n',
      help: 'The feature name (snake_case).',
      mandatory: true,
    );
    argParser.addOption(
      'output',
      abbr: 'o',
      help: 'App lib directory (defaults to lib/features).',
      defaultsTo: 'lib/features',
    );
    argParser.addOption(
      'test-output',
      help: 'App test directory (defaults to test/features).',
      defaultsTo: 'test/features',
    );
  }

  @override
  String get name => 'add-feature';

  @override
  String get description => 'Create a new feature in the app.';

  @override
  Future<void> run() async {
    final String featureName = argResults!['name'] as String;
    final String outputDir = argResults!['output'] as String;
    final String testOutputDir = argResults!['test-output'] as String;
    final String featurePath = p.join(outputDir, featureName);
    final String testPath = p.join(testOutputDir, featureName);

    if (Directory(featurePath).existsSync()) {
      stderr.writeln('Error: Directory "$featurePath" already exists.');
      exit(1);
    }

    stdout.writeln('Creating feature "$featureName" in $featurePath...');
    FeatureTemplate.generate(
      featureName: featureName,
      outputPath: featurePath,
      testOutputPath: testPath,
    );

    stdout.writeln('');
    stdout.writeln('Done! Next steps:');
    stdout.writeln('  1. Add @RoutePage() route to app_router.dart');
    stdout.writeln('  2. dart run build_runner build --delete-conflicting-outputs');
    stdout.writeln('  3. Override the repository provider in main.dart');
  }
}
