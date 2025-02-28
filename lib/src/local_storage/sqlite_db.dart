import 'dart:async';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SQLiteDB {
  static Database? _database;

  static Future<void> init() async {
    _database = await _initDB();
  }

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  static Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'offline_data.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE offline_data (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            key TEXT UNIQUE,
            value TEXT
          )
        ''');
      },
    );
  }

  static Future<void> insertData(String key, String value) async {
    final db = await database;
    await db.insert(
      'offline_data',
      {'key': key, 'value': value},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<String?> getData(String key) async {
    final db = await database;
    final result = await db.query(
      'offline_data',
      where: 'key = ?',
      whereArgs: [key],
    );
    return result.isNotEmpty ? result.first['value'] as String : null;
  }

  static Future<void> deleteData(String key) async {
    final db = await database;
    await db.delete('offline_data', where: 'key = ?', whereArgs: [key]);
  }
}
