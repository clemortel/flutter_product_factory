import 'package:factory_platform_interface/factory_platform_interface.dart';

/// In-memory [KeyValueStore] for testing and demos.
///
/// Data is lost when the process exits.
class InMemoryStore implements KeyValueStore {
  final Map<String, Object> _store = {};

  @override
  Future<String?> getString(String key) async => _store[key] as String?;

  @override
  Future<void> setString(String key, String value) async => _store[key] = value;

  @override
  Future<bool?> getBool(String key) async => _store[key] as bool?;

  @override
  Future<void> setBool(String key, {required bool value}) async =>
      _store[key] = value;

  @override
  Future<int?> getInt(String key) async => _store[key] as int?;

  @override
  Future<void> setInt(String key, int value) async => _store[key] = value;

  @override
  Future<void> remove(String key) async => _store.remove(key);

  @override
  Future<void> clear() async => _store.clear();
}
