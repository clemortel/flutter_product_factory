import 'dart:io';

import 'package:args/command_runner.dart';

/// Checks the development environment for required tools.
class DoctorCommand extends Command<void> {
  @override
  String get name => 'doctor';

  @override
  String get description => 'Check your environment for required tools.';

  @override
  Future<void> run() async {
    stdout.writeln('Flutter Product Factory — Doctor\n');

    final List<_Check> checks = [
      _Check('Flutter', 'flutter', ['--version']),
      _Check('Dart', 'dart', ['--version']),
      _Check('Melos', 'melos', ['--version']),
    ];

    bool allPassed = true;
    for (final check in checks) {
      final bool ok = await _runCheck(check);
      if (!ok) allPassed = false;
    }

    stdout.writeln('');
    if (allPassed) {
      stdout.writeln('All checks passed!');
    } else {
      stdout.writeln('Some checks failed. Install missing tools and retry.');
      exit(1);
    }
  }

  Future<bool> _runCheck(_Check check) async {
    try {
      final ProcessResult result = await Process.run(
        check.command,
        check.args,
        runInShell: true,
      );
      if (result.exitCode == 0) {
        final String version =
            (result.stdout as String).trim().split('\n').first;
        stdout.writeln('  [ok] ${check.name}: $version');
        return true;
      }
      stdout.writeln('  [FAIL] ${check.name}: exited with ${result.exitCode}');
      return false;
    } catch (_) {
      stdout.writeln('  [FAIL] ${check.name}: not found');
      return false;
    }
  }
}

class _Check {
  const _Check(this.name, this.command, this.args);

  final String name;
  final String command;
  final List<String> args;
}
