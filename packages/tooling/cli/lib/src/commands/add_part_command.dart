import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:path/path.dart' as p;

import '../templates/part_template.dart';

/// Scaffolds a new part package (UI composition layer).
class AddPartCommand extends Command<void> {
  AddPartCommand() {
    argParser.addOption(
      'name',
      abbr: 'n',
      help: 'The part name (snake_case, without "_part" suffix).',
      mandatory: true,
    );
    argParser.addOption(
      'feature',
      abbr: 'f',
      help: 'The feature package this part composes (e.g., "counter").',
      mandatory: true,
    );
    argParser.addOption(
      'output',
      abbr: 'o',
      help: 'Output directory.',
      defaultsTo: 'packages/parts',
    );
  }

  @override
  String get name => 'add-part';

  @override
  String get description => 'Create a new part package (UI composition layer).';

  @override
  Future<void> run() async {
    final String partName = argResults!['name'] as String;
    final String featureName = argResults!['feature'] as String;
    final String outputDir = argResults!['output'] as String;
    final String packageName = '${partName}_part';
    final String packagePath = p.join(outputDir, packageName);

    if (Directory(packagePath).existsSync()) {
      stderr.writeln('Error: Directory "$packagePath" already exists.');
      exit(1);
    }

    stdout.writeln('Creating part "$packageName" in $packagePath...');
    PartTemplate.generate(
      partName: partName,
      featureName: featureName,
      outputPath: packagePath,
    );
    stdout.writeln('Done! Next steps:');
    stdout.writeln('  1. Add "$packagePath" to the workspace in root pubspec.yaml');
    stdout.writeln('  2. Run: melos bootstrap');
  }
}
