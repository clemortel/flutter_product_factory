# CLI Documentation

The Factory CLI scaffolds new apps, features, and parts into your monorepo. It automatically updates the `workspace:` list in root `pubspec.yaml` — no manual editing needed.

## Installation

### Global activation (recommended)

```bash
# From a local clone
dart pub global activate --source path packages/tooling/cli

# From git
dart pub global activate --source git https://github.com/clemortel/flutter_product_factory.git --git-path packages/tooling/cli
```

After activation, the `factory` command is available globally. Run it from anywhere inside the monorepo root.

### Local (without activation)

```bash
cd packages/tooling/cli
dart pub get
dart run bin/factory.dart <command>
```

## Commands

### `factory new`

Creates a new Flutter app in the monorepo and adds it to the workspace.

```bash
factory new --name my_app
factory new --name my_app --output apps
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

**Next step:** `melos bootstrap`

### `factory add-feature`

Creates a new feature package with model, repository, Riverpod notifier, and test.

```bash
factory add-feature --name todo
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

**Next steps:** `melos bootstrap` then `melos run build_runner`

### `factory add-part`

Creates a new part package (UI composition layer) for a feature.

```bash
factory add-part --name todo --feature todo
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

**Next step:** `melos bootstrap`

### `factory doctor`

Checks your environment for required tools (Flutter, Dart, Melos).

```bash
factory doctor
```

## What the CLI Does Automatically

When you run `new`, `add-feature`, or `add-part`, the CLI:

1. Generates all package files (pubspec, lib, test)
2. Adds the new package path to the `workspace:` list in root `pubspec.yaml`
3. Prints the exact next commands you need to run

You never need to manually edit the workspace list.

## Codegen Reminder

Feature packages use Freezed and Riverpod codegen. After `melos bootstrap`, you must generate code:

```bash
melos run build_runner          # one-time generation
melos run build_runner:watch    # watch mode during development
```

The CLI does not run codegen automatically — this is intentional. Code generation can be slow and you may want to batch it after adding multiple packages.
