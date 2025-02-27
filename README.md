# Flutter Offline Sync

A Flutter package for offline data synchronization. This package enables seamless data sync between local storage and a remote server, ensuring smooth functionality even in offline mode.

## Features
- Automatic sync when the internet is available
- Local storage using Hive
- Background data synchronization
- Connectivity-aware sync mechanism

## Installation
Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  connectivity_plus: ^5.0.2
  hive: ^2.2.3
  hive_flutter: ^1.1.0
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
import 'package:flutter_offline_sync/src/sync_manager/sync_manager.dart';
import 'package:hive_flutter/hive_flutter.dart';

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
Create a `SyncManager` class to handle offline data storage and sync:

```dart
import 'package:hive/hive.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class SyncManager {
  late Box _box;

  Future<void> init() async {
    _box = await Hive.openBox('offline_data');
  }

  void saveData(String key, dynamic value) {
    _box.put(key, value);
  }

  Future<void> syncData() async {
    if (await Connectivity().checkConnectivity() != ConnectivityResult.none) {
      var offlineData = _box.toMap();
      // Send data to the server
      print("Syncing data: \$offlineData");
      _box.clear();
    }
  }
}
```

### 3. Store and Sync Data
Save data locally when offline and sync when online:

```dart
final syncManager = SyncManager();
syncManager.saveData('user', {'name': 'John Doe', 'age': 25});
```

## Running Tests
To run tests, execute:
```sh
flutter test
```

## Contributing
Contributions are welcome! Feel free to open an issue or submit a pull request.

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

