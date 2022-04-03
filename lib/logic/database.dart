import 'package:hive/hive.dart';

class Database {
  static const String _boxName = 'database';

  static late final Box _box;

  static bool isInitialize = false;

  static Future<void> init(String path) async {
    Hive.init(path);
    if (!isInitialize) _box = await Hive.openBox(_boxName);
    isInitialize = true;
  }

  static void createField(String key, String value, Function() onKeyExist) {
    if (containsKey(key)) {
      onKeyExist();
    } else {
      _box.put(key, value);
    }
  }

  static String? readField<String>(String key) {
    if (_box.containsKey(key)) {
      return _box.get(key);
    } else {
      return null;
    }
  }

  static void updateField(String key, dynamic value, Function() onKeyMissed) {
    if (containsKey(key)) {
      _box.put(key, value);
    } else {
      onKeyMissed();
    }
  }

  static void deleteField(String key, Function() onKeyMissed) {
    if (containsKey(key)) {
      _box.delete(key);
    } else {
      onKeyMissed();
    }
  }

  static Map<String, String> getAllFields() {
    return _box.toMap().map((key, value) => MapEntry(key, value));
  }

  static void deleteAllFields() {
    _box.deleteAll(getAllFields().keys);
  }

  static bool containsKey(String key) {
    if (_box.containsKey(key)) {
      return true;
    } else {
      return false;
    }
  }
}
