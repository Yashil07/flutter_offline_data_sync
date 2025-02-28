import 'package:hive_flutter/hive_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

/// A class to manage syncing of data.
class SyncManager {
  late Box _offlineBox;
  bool _isSyncing = false;

  /// Getter for sync status
  bool get isSyncing => _isSyncing;

  /// Initialize Hive storage
  Future<void> init() async {
    await Hive.initFlutter();
    _offlineBox = await Hive.openBox('offline_data');
  }

  /// Save data offline
  Future<void> saveOfflineData(String key, dynamic value) async {
    await _offlineBox.put(key, value);
  }

  /// Retrieve offline data
  dynamic getOfflineData(String key) {
    return _offlineBox.get(key);
  }

  /// Sync data when online
  Future<void> syncData() async {
    var connectivityResult = await Connectivity().checkConnectivity();

    // ignore: unrelated_type_equality_checks
    if (connectivityResult != ConnectivityResult.none) {
      _isSyncing = true;
      _offlineBox.clear(); // Clear offline data after syncing
      _isSyncing = false;
    }
  }
}
