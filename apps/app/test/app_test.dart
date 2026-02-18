import 'package:app/app.dart';
import 'package:app/features/counter/counter_notifier.dart';
import 'package:app/features/counter/fake_counter_repository.dart';
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
        child: App(),
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
        child: App(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('+'));
    await tester.pumpAndSettle();

    expect(find.text('1'), findsOneWidget);
  });
}
