import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_offline_data_sync/flutter_offline_data_sync.dart';
import 'package:flutter_offline_data_sync/src/sync_manager/sync_manager.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      (MethodCall methodCall) async {
        return '.'; // Mocking a directory path
      },
    );
  });

  test('SyncManager initializes correctly', () async {
    final syncManager = SyncManager();
    await syncManager.init();
    expect(syncManager, isNotNull);
  });
}
