import 'package:hive/hive.dart';

class LocalDB {
  static Future<void> init() async {
    Hive.init('offline_sync_db');
  }

  static Future<void> saveData(String key, dynamic value) async {
    var box = await Hive.openBox('dataBox');
    await box.put(key, value);
  }

  static dynamic getData(String key) {
    var box = Hive.box('dataBox');
    return box.get(key);
  }

  static Future<void> deleteData(String key) async {
    var box = Hive.box('dataBox');
    await box.delete(key);
  }
}