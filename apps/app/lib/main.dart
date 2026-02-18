import 'package:feature_counter/feature_counter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    ProviderScope(
      overrides: [
        counterRepositoryProvider.overrideWithValue(
          FakeCounterRepository(),
        ),
      ],
      child: const App(),
    ),
  );
}
