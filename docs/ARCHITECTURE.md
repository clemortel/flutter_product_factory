# Architecture

## Layer Diagram

```
Layer 4 — apps/demo_app
  └─ depends on: counter_part, factory_ui, factory_http, factory_storage, factory_analytics

Layer 3 — parts/counter_part
  └─ depends on: feature_counter, factory_ui, go_router

Layer 2 — features/feature_counter
  └─ depends on: factory_core, factory_async, factory_platform_interface, riverpod+codegen

Layer 1 — platform/*
  ├─ factory_http         → factory_platform_interface, factory_core, http
  ├─ factory_storage      → factory_platform_interface, shared_preferences
  └─ factory_analytics    → factory_platform_interface

Layer 0 — foundation/*
  ├─ factory_core         → fpdart (re-exports Either)
  ├─ factory_async        → factory_core, freezed
  ├─ factory_logging      → (no deps)
  └─ factory_env          → (no deps)

Sidebar — factory_platform_interface → factory_core (interfaces only)
Sidebar — factory_ui → Flutter SDK only (publishable, zero business deps)
Sidebar — tooling/cli → args, path, yaml (Dart-only, no Flutter)
```

## Dependency Rule

Packages **only depend downward** — never upward or sideways within the same layer.

- A **feature** may depend on foundation and platform interface packages.
- A **part** may depend on features, UI, and foundation packages.
- An **app** wires everything together at the top.

## Avoiding Circular Dependencies

In a modular Riverpod architecture, circular provider dependencies are a common failure mode. Follow these rules:

1. **Never invalidate a provider from a provider it watches.** If provider A watches provider B, then B must not invalidate A. The UI layer is the only place that should trigger `ref.invalidate()`.
2. **Providers read downward, never upward.** A feature provider must not `ref.watch` a part-level or app-level provider. If you need data from a higher layer, pass it as a parameter.
3. **Keep `ref.listen` one-directional.** If two providers listen to each other, you have a cycle. Refactor one to take the value as a build argument.
4. **Test with `ProviderContainer` in isolation.** If you need to override more than 2-3 providers to test a single notifier, your dependency graph is likely too coupled.

## Package Categories

### Foundation (`packages/foundation/`)

Low-level building blocks with zero or minimal dependencies.

| Package | Purpose |
|---------|---------|
| `factory_core` | Sealed `Failure` class, fpdart `Either` re-exports, type aliases |
| `factory_async` | `AsyncState<T>` Freezed wrapper for async operations |
| `factory_logging` | `AppLogger` interface + `PrintLogger` |
| `factory_env` | `EnvConfig` class for environment configuration |

### Platform (`packages/platform/`)

Backend-agnostic interfaces and their concrete implementations.

| Package | Purpose |
|---------|---------|
| `factory_platform_interface` | Abstract `ApiClient`, `AuthGateway`, `AnalyticsGateway`, `KeyValueStore` |
| `factory_http` | `HttpApiClient` (real) + `FakeApiClient` (in-memory) |
| `factory_storage` | `SharedPrefsStore` + `InMemoryStore` |
| `factory_analytics` | `NoopAnalytics` default |

### UI (`packages/ui/`)

Pure Flutter widgets and design tokens. **Zero business logic dependencies** — can be published independently.

### Features (`packages/features/`)

Domain logic packages containing:
- **Models** — Freezed state classes
- **Repositories** — Interface + fake implementation
- **Providers** — Riverpod notifiers managing `AsyncState<T>`

### Parts (`packages/parts/`)

UI composition packages that wire features to pages and routes. Each part:
- Depends on one or more features
- Provides a `ConsumerWidget` page
- Exports a `GoRoute` for the router

### Apps (`apps/`)

Top-level Flutter applications that compose parts, provide platform implementations, and configure routing.

## State Management

### AsyncState

```dart
@Freezed(genericArgumentFactories: true)
sealed class AsyncState<T> with _$AsyncState<T> {
  const factory AsyncState.idle() = AsyncStateIdle<T>;
  const factory AsyncState.loading() = AsyncStateLoading<T>;
  const factory AsyncState.success(T data) = AsyncStateSuccess<T>;
  const factory AsyncState.error(Failure failure) = AsyncStateError<T>;
}
```

### Notifier Pattern

```dart
@riverpod
class Counter extends _$Counter {
  @override
  AsyncState<CounterState> build() {
    _fetch();
    return const AsyncState.loading();
  }
}
```

Class name `Counter` generates provider `counterProvider`.

### Repository Pattern

```dart
@Riverpod(keepAlive: true)
CounterRepository counterRepository(Ref ref) {
  throw UnimplementedError('Must be overridden');
}
```

Override in app:

```dart
ProviderScope(
  overrides: [
    counterRepositoryProvider.overrideWithValue(FakeCounterRepository()),
  ],
  child: const App(),
)
```

## Error Handling

All repository methods return `Either<Failure, T>`. The sealed `Failure` class enables exhaustive pattern matching:

```dart
sealed class Failure {
  const Failure(this.message);
  final String message;
}

final class NetworkFailure extends Failure { ... }
final class ServerFailure extends Failure { ... }
final class NotFoundFailure extends Failure { ... }
final class UnauthorizedFailure extends Failure { ... }
final class ValidationFailure extends Failure { ... }
final class UnknownFailure extends Failure { ... }
```

## Workspace Configuration

This project uses **Melos 7.x** which reads all config from the root `pubspec.yaml`:

- `workspace:` — lists all packages (no glob support, explicit paths)
- `melos: scripts:` — defines CLI scripts like `analyze`, `test`, `build_runner`
- Each package has `resolution: workspace` in its `pubspec.yaml`

There is no `melos.yaml` file. The CLI's `factory new`, `add-feature`, and `add-part` commands automatically update the `workspace:` list when scaffolding new packages.
