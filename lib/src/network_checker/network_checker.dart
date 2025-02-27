import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';

class NetworkChecker {
  static final _connectivity = Connectivity();
  static final _controller = StreamController<bool>.broadcast();

  static Stream<bool> get onConnectionChange => _controller.stream;

  static void init() {
    _connectivity.onConnectivityChanged.listen((result) {
      _controller.add(result != ConnectivityResult.none);
    });
  }
}