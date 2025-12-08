import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  final StreamController<bool> _connectionStatusController = StreamController<bool>.broadcast();

  Stream<bool> get connectionStatusStream => _connectionStatusController.stream;

  ConnectivityService() {
    _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      _checkStatus(result);
    });
  }


  Future<bool> get isConnected async {
    final result = await _connectivity.checkConnectivity();
    return _isOnline(result);
  }

  void _checkStatus(ConnectivityResult result) {
    bool isOnline = _isOnline(result);
    _connectionStatusController.add(isOnline);
  }

  bool _isOnline(ConnectivityResult result) {
    return result != ConnectivityResult.none;
  }

  void dispose() {
    _connectionStatusController.close();
  }
}