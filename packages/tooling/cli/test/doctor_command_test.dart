import 'package:args/command_runner.dart';
import 'package:factory_cli/src/commands/doctor_command.dart';
import 'package:test/test.dart';

void main() {
  group('DoctorCommand', () {
    late CommandRunner<void> runner;

    setUp(() {
      runner = CommandRunner<void>('test', 'test')..addCommand(DoctorCommand());
    });

    test('command is registered with correct name', () {
      expect(runner.commands.containsKey('doctor'), isTrue);
    });

    test('has correct description', () {
      final command = runner.commands['doctor']!;
      expect(
        command.description,
        'Check your environment for required tools.',
      );
    });
  });
}
