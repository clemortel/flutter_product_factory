import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:path/path.dart' as p;

import '../templates/app_template.dart';
import '../utils/workspace_updater.dart';

/// Scaffolds a new Flutter app wired into the monorepo.
class NewAppCommand extends Command<void> {
  NewAppCommand() {
    argParser.addOption(
      'name',
      abbr: 'n',
      help: 'The app name (snake_case).',
      mandatory: true,
    );
    argParser.addOption(
      'output',
      abbr: 'o',
      help: 'Output directory (defaults to apps/).',
      defaultsTo: 'apps',
    );
  }

  @override
  String get name => 'new';

  @override
  String get description => 'Create a new Flutter app in the monorepo.';

  @override
  Future<void> run() async {
    final String appName = argResults!['name'] as String;
    final String outputDir = argResults!['output'] as String;
    final String appPath = p.join(outputDir, appName);

    if (Directory(appPath).existsSync()) {
      stderr.writeln('Error: Directory "$appPath" already exists.');
      exit(1);
    }

    stdout.writeln('Creating app "$appName" in $appPath...');
    AppTemplate.generate(appName: appName, outputPath: appPath);

    final bool added = addToWorkspace(appPath);
    if (added) {
      stdout.writeln('Added "$appPath" to workspace in root pubspec.yaml.');
    }

    stdout.writeln('');
    stdout.writeln('Done! Next steps:');
    stdout.writeln('  1. melos bootstrap');
    stdout.writeln('  2. cd $appPath && flutter run');
  }
}
