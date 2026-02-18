import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ui/ui.dart';

import 'counter_notifier.dart';
import 'counter_state.dart';

/// Full-screen counter page consuming [counterProvider].
@RoutePage()
class CounterPage extends ConsumerWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<CounterState> asyncState = ref.watch(counterProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Counter')),
      body: Center(
        child: asyncState.when(
          loading: () => const CircularProgressIndicator(),
          data: (CounterState data) => _CounterBody(state: data),
          error: (Object error, _) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Error: $error',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: FactorySpacing.md),
              FactoryButton(
                label: 'Retry',
                onPressed: () => ref.invalidate(counterProvider),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CounterBody extends ConsumerWidget {
  const _CounterBody({required this.state});

  final CounterState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '${state.count}',
          style: Theme.of(context).textTheme.displayLarge,
        ),
        const SizedBox(height: FactorySpacing.lg),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FactoryButton(
              label: '-',
              onPressed: () =>
                  ref.read(counterProvider.notifier).decrement(),
            ),
            const SizedBox(width: FactorySpacing.md),
            FactoryButton(
              label: '+',
              onPressed: () =>
                  ref.read(counterProvider.notifier).increment(),
            ),
          ],
        ),
        const SizedBox(height: FactorySpacing.md),
        FactoryButton(
          label: 'Reset',
          icon: Icons.refresh,
          onPressed: () => ref.read(counterProvider.notifier).reset(),
        ),
      ],
    );
  }
}
