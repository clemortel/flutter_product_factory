import 'package:demo_app/app.dart';
import 'package:feature_counter/feature_counter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App renders without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          counterRepositoryProvider.overrideWithValue(
            FakeCounterRepository(),
          ),
        ],
        child: const App(),
      ),
    );

    // Wait for async operations to complete.
    await tester.pumpAndSettle();

    expect(find.text('Counter'), findsOneWidget);
    expect(find.text('0'), findsOneWidget);
  });

  testWidgets('Increment button increases counter', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          counterRepositoryProvider.overrideWithValue(
            FakeCounterRepository(),
          ),
        ],
        child: const App(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('+'));
    await tester.pumpAndSettle();

    expect(find.text('1'), findsOneWidget);
  });
}
