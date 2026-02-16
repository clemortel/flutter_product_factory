import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:factory_cli/src/commands/add_feature_command.dart';
import 'package:factory_cli/src/commands/add_part_command.dart';
import 'package:factory_cli/src/commands/doctor_command.dart';
import 'package:factory_cli/src/commands/new_app_command.dart';

void main(List<String> args) async {
  final CommandRunner<void> runner = CommandRunner<void>(
    'factory',
    'Flutter Product Factory CLI — scaffold apps, features, and parts.',
  )
    ..addCommand(NewAppCommand())
    ..addCommand(AddFeatureCommand())
    ..addCommand(AddPartCommand())
    ..addCommand(DoctorCommand());

  try {
    await runner.run(args);
  } on UsageException catch (e) {
    stderr.writeln(e);
    exit(64);
  }
}
