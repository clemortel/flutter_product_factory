import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:path/path.dart' as p;

import '../templates/feature_template.dart';
import '../utils/workspace_updater.dart';

/// Scaffolds a new feature package.
class AddFeatureCommand extends Command<void> {
  AddFeatureCommand() {
    argParser.addOption(
      'name',
      abbr: 'n',
      help: 'The feature name (snake_case, without "feature_" prefix).',
      mandatory: true,
    );
    argParser.addOption(
      'output',
      abbr: 'o',
      help: 'Output directory.',
      defaultsTo: 'packages/features',
    );
  }

  @override
  String get name => 'add-feature';

  @override
  String get description => 'Create a new feature package.';

  @override
  Future<void> run() async {
    final String featureName = argResults!['name'] as String;
    final String outputDir = argResults!['output'] as String;
    final String packageName = 'feature_$featureName';
    final String packagePath = p.join(outputDir, packageName);

    if (Directory(packagePath).existsSync()) {
      stderr.writeln('Error: Directory "$packagePath" already exists.');
      exit(1);
    }

    stdout.writeln('Creating feature "$packageName" in $packagePath...');
    FeatureTemplate.generate(
      featureName: featureName,
      outputPath: packagePath,
    );

    final bool added = addToWorkspace(packagePath);
    if (added) {
      stdout.writeln('Added "$packagePath" to workspace in root pubspec.yaml.');
    }

    stdout.writeln('');
    stdout.writeln('Done! Next steps:');
    stdout.writeln('  melos bootstrap');
    stdout.writeln('  melos run build_runner');
  }
}
