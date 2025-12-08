import 'dart:async';
import 'package:flutter/material.dart';
import '../data/services/mqtt_service.dart';
import '../models/remote_track.dart'; 

class HomeProvider with ChangeNotifier {
  final MqttService _mqttService;
  
  List<RemoteTrack> _remoteTracks = [];
  bool _isLoading = true;
  StreamSubscription<dynamic>? _mqttSubscription;

  List<RemoteTrack> get remoteTracks => _remoteTracks;
  bool get isLoading => _isLoading;
  bool get isMqttConnected => _mqttService.isConnected;

  HomeProvider(this._mqttService) {
    _initMqtt();
  }

  void _initMqtt() {
    _isLoading = true;
    notifyListeners();

    _mqttService.connect();

    _mqttSubscription = _mqttService.dataStream.listen((newData) {
      _remoteTracks = newData;
      _isLoading = false;
      notifyListeners();
    }, onError: (e) {
        _isLoading = false;
        notifyListeners();
    });
  }
  
  void reconnectMqtt() {
     _mqttService.disconnect();
     _mqttService.connect();
  }

  @override
  void dispose() {
    _mqttSubscription?.cancel();
    super.dispose();
  }
}