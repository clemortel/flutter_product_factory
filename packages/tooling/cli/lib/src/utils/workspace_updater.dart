import 'dart:io';

import 'package:yaml_edit/yaml_edit.dart';

/// Adds a package path to the `workspace:` list in the root `pubspec.yaml`.
///
/// Walks up from [startDir] to find the root pubspec containing `workspace:`.
/// Returns `true` if the path was added, `false` if already present or
/// the root pubspec was not found.
bool addToWorkspace(String packagePath, {String? startDir}) {
  final File? rootPubspec = _findRootPubspec(startDir ?? Directory.current.path);
  if (rootPubspec == null) {
    stderr.writeln('Warning: Could not find root pubspec.yaml with workspace field.');
    return false;
  }

  final String content = rootPubspec.readAsStringSync();
  final YamlEditor editor = YamlEditor(content);

  // Check if workspace key exists.
  final dynamic workspace = editor.parseAt(['workspace']).value;
  if (workspace is! List) {
    stderr.writeln('Warning: workspace field is not a list in ${rootPubspec.path}.');
    return false;
  }

  // Normalize path separators.
  final String normalized = packagePath.replaceAll('\\', '/');

  // Check if already present.
  for (final dynamic entry in workspace) {
    if (entry.toString() == normalized) {
      return false;
    }
  }

  // Append to the list.
  editor.appendToList(['workspace'], normalized);
  rootPubspec.writeAsStringSync(editor.toString());
  return true;
}

/// Walks up from [startPath] looking for a pubspec.yaml that contains
/// a `workspace:` key.
File? _findRootPubspec(String startPath) {
  Directory dir = Directory(startPath);
  while (true) {
    final File pubspec = File('${dir.path}/pubspec.yaml');
    if (pubspec.existsSync()) {
      final String content = pubspec.readAsStringSync();
      if (content.contains('workspace:')) {
        return pubspec;
      }
    }
    final Directory parent = dir.parent;
    if (parent.path == dir.path) break; // reached filesystem root
    dir = parent;
  }
  return null;
}
