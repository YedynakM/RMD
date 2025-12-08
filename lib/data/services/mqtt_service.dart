import 'dart:async';
import 'dart:io';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import '/models/remote_track.dart';

class MqttService {
  // Використовуємо правильну схему для WebSocket підключення HiveMQ
  final String broker = 'ws://broker.hivemq.com/mqtt';
  final String topic = 'music/yammy/full';
  late final String clientIdentifier;

  late MqttServerClient _client;
  
  // Стрім тепер типізовано під MusicTrack
  final StreamController<List<RemoteTrack>> _dataStreamController = StreamController.broadcast();

  Stream<List<RemoteTrack>> get dataStream => _dataStreamController.stream;
  
  bool get isConnected => _client.connectionStatus?.state == MqttConnectionState.connected;

  MqttService() {
    clientIdentifier = 'flutter_music_client_${DateTime.now().millisecondsSinceEpoch % 10000}';
    
    _client = MqttServerClient(broker, clientIdentifier);
    _client.port = 8000;
    _client.useWebSocket = true;
    _client.websocketProtocols = ['mqtt'];
    _client.secure = false;
    _client.keepAlivePeriod = 60;
    _client.logging(on: true);

    _client.onDisconnected = _onDisconnected;
    _client.onConnected = _onConnected;
    _client.onSubscribed = _onSubscribed;

    final connMessage = MqttConnectMessage()
        .withClientIdentifier(clientIdentifier)
        .startClean()
        .withWillQos(MqttQos.atMostOnce);
    _client.connectionMessage = connMessage;
  }

  Future<void> connect() async {
    if (isConnected) return;

    try {
      print('MQTT: Connecting to $broker...');
      await _client.connect();
    } on NoConnectionException catch (e) {
      print('MQTT: Client exception - $e');
      _client.disconnect();
    } on SocketException catch (e) {
      print('MQTT: Socket exception - $e');
      _client.disconnect();
    } catch (e) {
      print('MQTT: Unknown error - $e');
      _client.disconnect();
    }

    if (_client.connectionStatus!.state == MqttConnectionState.connected) {
      print('MQTT: Connected');
      _subscribeToTopic();
    } else {
      print('MQTT: Connection failed - status is ${_client.connectionStatus!.state}');
      _client.disconnect();
    }
  }

  void _subscribeToTopic() {
    print('MQTT: Subscribing to $topic');
    _client.subscribe(topic, MqttQos.atMostOnce);

    _client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final MqttPublishMessage recMess = c![0].payload as MqttPublishMessage;
      final String payload =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

      print('MQTT: Received music payload: $payload');
      
      try {
        if (payload.isNotEmpty) {
           // Використовуємо метод парсингу з моделі MusicTrack
           final tracks = RemoteTrack.parseList(payload);
           
           if (tracks.isNotEmpty) {
             _dataStreamController.add(tracks);
           } else {
             print('MQTT: Warning - Parsed list is empty (check JSON structure)');
           }
        }
      } catch (e) {
        print('MQTT: Error parsing music data - $e');
      }
    });
  }

  void disconnect() {
    _client.disconnect();
  }

  void _onConnected() {
    print('MQTT: Connected callback');
  }

  void _onDisconnected() {
    print('MQTT: Disconnected callback');
  }

  void _onSubscribed(String topic) {
    print('MQTT: Subscribed to $topic');
  }
   
  void dispose() {
    _dataStreamController.close();
    disconnect();
  }
}