import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'sqlite_db.dart';

class LocalDB {
  static late Box _box;
  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return; // Prevent re-initialization

    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path); // Initialize Hive with the correct path

    _box = await Hive.openBox('offline_data');
    await SQLiteDB.init(); // Initialize SQLite

    _initialized = true; // Mark as initialized
  }

  static Future<void> saveData(String key, String value) async {
    await _box.put(key, value);
    await SQLiteDB.insertData(key, value);
  }

  static Future<String?> getData(String key) async {
    return _box.get(key) ?? await SQLiteDB.getData(key);
  }

  static Future<void> deleteData(String key) async {
    await _box.delete(key);
    await SQLiteDB.deleteData(key);
  }
}