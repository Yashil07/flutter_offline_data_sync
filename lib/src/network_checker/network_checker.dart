import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';

/// A class to check network connectivity
class NetworkChecker {
  static final _connectivity = Connectivity();
  static final _controller = StreamController<bool>.broadcast();

  static Stream<bool> get onConnectionChange => _controller.stream;

  static void init() {
    _connectivity.onConnectivityChanged.listen((results) {
      // Check if any of the results indicate an active connection
      bool isConnected = results.isNotEmpty && results.any((result) => result != ConnectivityResult.none);
      _controller.add(isConnected);
    });
  }
}
