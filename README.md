# Flutter Offline Sync

A Flutter package for offline data synchronization using both **Hive** and **SQLite**. This package ensures smooth data persistence and syncs with a remote server when the internet is available.

## Features
- **Dual Storage**: Stores data using Hive (NoSQL) and SQLite (Relational DB).
- **Automatic Sync**: Data syncs with the server when online.
- **Background Sync**: Monitors connectivity changes for auto-sync.
- **Optimized Read/Write**: Uses the best available storage option.
- **Custom Sync Implementation**: Allows defining custom sync logic.
- **Error Handling**: Ensures safe data transactions.

## Installation
Add the package dependencies to your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  connectivity_plus: ^5.0.2
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  sqflite: ^2.3.0
  path_provider: ^2.1.2
```

Run:
```sh
flutter pub get
```

## Usage

### 1. Initialize Sync Manager
In your `main.dart`, initialize the sync manager:

```dart
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'sync_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  final syncManager = SyncManager();
  await syncManager.init();

  Connectivity().onConnectivityChanged.listen((event) {
    if (event != ConnectivityResult.none) {
      syncManager.syncData();
    }
  });

  runApp(MyApp());
}
```

### 2. Implement SyncManager
Create a `SyncManager` class to handle offline data storage and synchronization:

```dart
import 'package:hive/hive.dart';
import 'sqlite_db.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

/// Manages offline data synchronization and local storage.
class SyncManager {
  late Box _box;

  /// Initializes Hive and SQLite databases.
  Future<void> init() async {
    _box = await Hive.openBox('offline_data');
    await SQLiteDB.init();
  }

  /// Saves data to both Hive and SQLite.
  Future<void> saveData(String key, dynamic value) async {
    _box.put(key, value);
    await SQLiteDB.insertData(key, value.toString());
  }

  /// Retrieves data from Hive first, then SQLite as fallback.
  Future<String?> getData(String key) async {
    return _box.get(key) ?? await SQLiteDB.getData(key);
  }

  /// Synchronizes offline data with the remote server when online.
  Future<void> syncData() async {
    if (await Connectivity().checkConnectivity() != ConnectivityResult.none) {
      var offlineData = _box.toMap();
      // Send data to the server
      print("Syncing data: \$offlineData");
      _box.clear();
      await SQLiteDB.clearDatabase();
    }
  }
}
```

### 3. SQLite Database Implementation
Create `sqlite_db.dart` to manage SQLite storage:

```dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SQLiteDB {
  static Database? _database;

  static Future<void> init() async {
    _database = await _initDB();
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
    final db = await _database;
    await db?.insert('offline_data', {'key': key, 'value': value}, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<String?> getData(String key) async {
    final db = await _database;
    final result = await db?.query('offline_data', where: 'key = ?', whereArgs: [key]);
    return result?.isNotEmpty == true ? result!.first['value'] as String : null;
  }

  static Future<void> clearDatabase() async {
    final db = await _database;
    await db?.delete('offline_data');
  }
}
```

### 4. Storing and Syncing Data
Save data locally and sync when online:

```dart
final syncManager = SyncManager();
await syncManager.saveData('user', {'name': 'John Doe', 'age': 25});
```

Retrieve stored data:

```dart
String? userData = await syncManager.getData('user');
print(userData);
```

## Running Tests
To run tests, execute:
```sh
flutter test
```

## Example Project
Check out the `/example` folder for a complete working example.

### How to Run Example
1. Navigate to the example folder:
   ```sh
   cd example
   ```
2. Run the Flutter project:
   ```sh
   flutter run
   ```

## Contributing
We welcome contributions! If you would like to contribute:
- Fork the repository.
- Create a new branch.
- Make your changes and submit a pull request.

For major changes, please open an issue first to discuss your proposal.

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

