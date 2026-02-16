# Flutter Product Factory

A production-ready Flutter monorepo template with a Dart CLI that scaffolds new apps, features, and parts.

Demonstrates layered architecture with Riverpod 2.6 codegen, backend-agnostic platform abstractions, and clean separation of concerns.

## Quick Start

```bash
# Prerequisites
flutter --version   # >= 3.8.0
dart pub global activate melos

# Setup
git clone https://github.com/clemortel/flutter_product_factory.git
cd flutter_product_factory
melos bootstrap
melos run build_runner

# Run the demo
cd apps/demo_app
flutter run
```

> **Note:** There is no `melos.yaml` file. Melos 7.x reads all config from `pubspec.yaml` — the `workspace:` list and `melos:` scripts section both live there.

## Install the CLI

```bash
# From within the repo (local development)
dart pub global activate --source path packages/tooling/cli

# From git
dart pub global activate --source git https://github.com/clemortel/flutter_product_factory.git --git-path packages/tooling/cli

# Then use it from anywhere inside the monorepo
factory doctor
factory new --name my_app
factory add-feature --name auth
factory add-part --name auth --feature auth
```

The CLI auto-updates the `workspace:` list in root `pubspec.yaml` — no manual editing needed.

## Architecture

```
Layer 4  apps/demo_app
Layer 3  packages/parts/*        (UI composition)
Layer 2  packages/features/*     (domain logic + state)
Layer 1  packages/platform/*     (backend implementations)
Layer 0  packages/foundation/*   (core types, async, logging)
Sidebar  packages/ui/*           (pure UI, zero business deps)
```

Packages only depend **downward** — never upward or sideways within the same layer. See [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) for details.

## Key Patterns

### AsyncState

Custom `AsyncState<T>` wrapper (not Riverpod's AsyncValue) with four states:

```dart
return switch (state) {
  AsyncStateIdle() || AsyncStateLoading() => const CircularProgressIndicator(),
  AsyncStateSuccess(:final data) => DataView(data: data),
  AsyncStateError(:final failure) => ErrorView(failure: failure),
};
```

### Either-based error handling

All repository methods return `Either<Failure, T>` from fpdart:

```dart
FutureEither<User> getUser(String id) async {
  try {
    final response = await apiClient.get('/users/$id');
    return right(User.fromJson(response.data));
  } catch (e) {
    return left(NetworkFailure(e.toString()));
  }
}
```

### Riverpod Notifier Naming

Class name = `Counter` (not `CounterNotifier`), which generates `counterProvider`. Uses Riverpod 2.6 codegen with `Ref` (not the deprecated generated ref types).

## Project Structure

```
flutter_product_factory/
├── apps/demo_app/                    # Working demo app
├── packages/
│   ├── foundation/                   # Core types, async state, logging, env
│   ├── platform/                     # Backend abstractions + implementations
│   ├── ui/factory_ui/                # Design tokens + widgets (publishable)
│   ├── features/feature_counter/     # Example domain feature
│   ├── parts/counter_part/           # UI composition for counter
│   ├── widgetbook/factory_widgetbook/ # Component catalog
│   └── tooling/cli/                  # Dart CLI scaffolder
├── docs/                            # Architecture & CLI docs
└── pubspec.yaml                     # Workspace + Melos config (no melos.yaml)
```

## Commands

| Command | Description |
|---------|-------------|
| `melos bootstrap` | Install dependencies across all packages |
| `melos run analyze` | Run dart analyze on all packages |
| `melos run test` | Run tests in all packages |
| `melos run build_runner` | Generate code (Freezed, Riverpod) |
| `melos run build_runner:watch` | Watch mode for code generation |

## Technologies

- **Flutter** >= 3.8.0
- **Riverpod** 2.6 with codegen (`@riverpod`)
- **Freezed** 3.x for immutable models
- **fpdart** for Either/Option
- **go_router** for navigation
- **Melos** 7.x for monorepo management (config in `pubspec.yaml`)
- **Widgetbook** for component catalog

## License

MIT
