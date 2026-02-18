import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'env/env.dart';
import 'features/counter/counter_notifier.dart';
import 'features/counter/fake_counter_repository.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  const EnvConfig envConfig = EnvConfig(
    apiBaseUrl: Env.apiBaseUrl,
    environment: Env.environment,
  );

  final Talker talker = Talker();
  talker.info('Starting app in ${envConfig.environment} mode');

  runApp(
    ProviderScope(
      overrides: [
        counterRepositoryProvider.overrideWithValue(
          FakeCounterRepository(),
        ),
      ],
      child: App(),
    ),
  );
}
