import 'dart:async';
import 'package:flutter/material.dart';
import '../data/repositories/i_auth_repository.dart';
import '../data/services/connectivity_service.dart';

enum AuthStatus { initial, tryingAutoLogin, authenticated, unauthenticated }

class AuthProvider with ChangeNotifier {
  final IAuthRepository _authRepository;
  final ConnectivityService _connectivityService;
  
  AuthStatus _status = AuthStatus.initial;
  String? _currentUsername;
  bool _isOffline = false;
  StreamSubscription<bool>? _connectivitySubscription;

  AuthStatus get status => _status;
  String? get currentUsername => _currentUsername;
  bool get isOffline => _isOffline;

  AuthProvider(this._authRepository, this._connectivityService) {
    _init();
  }

  void _init() {
    _connectivitySubscription = _connectivityService.connectionStatusStream.listen((isConnected) {
      _isOffline = !isConnected;
      notifyListeners();
    });

    tryAutoLogin();
  }

  Future<void> tryAutoLogin() async {
    _status = AuthStatus.tryingAutoLogin;
    notifyListeners();

    final hasSession = await _authRepository.checkAuthStatus();
    if (hasSession) {
       _currentUsername = await _authRepository.getCurrentUsername();
      _status = AuthStatus.authenticated;
    } else {
      _status = AuthStatus.unauthenticated;
    }
    notifyListeners();
  }

  Future<String?> login(String username, String password) async {
    if (await _connectivityService.isConnected == false) {
      return "Відсутнє з'єднання з інтернетом";
    }

    final success = await _authRepository.login(username, password);
    if (success) {
       _currentUsername = username;
      _status = AuthStatus.authenticated;
      notifyListeners();
      return null;
    } else {
      return "Невірний логін або пароль";
    }
  }

  Future<String?> register(String username, String password) async {
     if (await _connectivityService.isConnected == false) {
      return "Відсутнє з'єднання з інтернетом для реєстрації";
    }
    final success = await _authRepository.register(username, password);
    if (success) {
      return null;
    } else {
      return "Помилка реєстрації";
    }
  }

  Future<void> logout() async {
    await _authRepository.logout();
    _currentUsername = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }
  
  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }
}