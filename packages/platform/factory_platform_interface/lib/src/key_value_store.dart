/// Simple key-value storage contract.
///
/// Implement this with SharedPreferences, Hive, or any other
/// local persistence mechanism.
abstract interface class KeyValueStore {
  Future<String?> getString(String key);
  Future<void> setString(String key, String value);
  Future<bool?> getBool(String key);
  Future<void> setBool(String key, {required bool value});
  Future<int?> getInt(String key);
  Future<void> setInt(String key, int value);
  Future<void> remove(String key);
  Future<void> clear();
}
