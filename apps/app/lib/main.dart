import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'features/counter/counter_notifier.dart';
import 'features/counter/fake_counter_repository.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

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
