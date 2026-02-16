# CLI Documentation

The Factory CLI scaffolds new apps, features, and parts into your monorepo.

## Installation

```bash
cd packages/tooling/cli
dart pub get
```

## Commands

### `factory new`

Creates a new Flutter app in the monorepo.

```bash
dart run bin/factory.dart new --name my_app
dart run bin/factory.dart new --name my_app --output apps
```

**Options:**
| Flag | Short | Required | Default | Description |
|------|-------|----------|---------|-------------|
| `--name` | `-n` | Yes | — | App name (snake_case) |
| `--output` | `-o` | No | `apps` | Output directory |

**Generated files:**
```
apps/my_app/
├── pubspec.yaml
├── lib/
│   ├── main.dart
│   ├── app.dart
│   └── router.dart
└── test/
    └── app_test.dart
```

### `factory add-feature`

Creates a new feature package with model, repository, provider, and test.

```bash
dart run bin/factory.dart add-feature --name todo
```

**Options:**
| Flag | Short | Required | Default | Description |
|------|-------|----------|---------|-------------|
| `--name` | `-n` | Yes | — | Feature name without `feature_` prefix |
| `--output` | `-o` | No | `packages/features` | Output directory |

**Generated files:**
```
packages/features/feature_todo/
├── pubspec.yaml
├── lib/
│   ├── feature_todo.dart
│   └── src/
│       ├── models/todo_state.dart
│       ├── repositories/
│       │   ├── todo_repository.dart
│       │   └── fake_todo_repository.dart
│       └── providers/todo.dart
└── test/
    └── todo_test.dart
```

### `factory add-part`

Creates a new part package (UI composition layer) for a feature.

```bash
dart run bin/factory.dart add-part --name todo --feature todo
```

**Options:**
| Flag | Short | Required | Default | Description |
|------|-------|----------|---------|-------------|
| `--name` | `-n` | Yes | — | Part name without `_part` suffix |
| `--feature` | `-f` | Yes | — | Feature package this part composes |
| `--output` | `-o` | No | `packages/parts` | Output directory |

**Generated files:**
```
packages/parts/todo_part/
├── pubspec.yaml
├── lib/
│   ├── todo_part.dart
│   └── src/
│       ├── todo_page.dart
│       └── todo_route.dart
```

### `factory doctor`

Checks your environment for required tools (Flutter, Dart, Melos).

```bash
dart run bin/factory.dart doctor
```

## After Scaffolding

After generating any package:

1. Add the new package path to the `workspace:` list in root `pubspec.yaml`
2. Run `melos bootstrap` to link dependencies
3. Run `melos run build_runner` if the package uses code generation (features with Freezed/Riverpod)
