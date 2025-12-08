import 'package:rmd_lab/data/repositories/i_auth_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const _keyUsername = 'secure_username';
const _keyPassword = 'secure_password';
const _keyIsLoggedIn = 'is_logged_in_flag';

class LocalAuthRepository implements IAuthRepository {
  final _storage = const FlutterSecureStorage();

  @override
  Future<bool> register(String username, String password) async {
    try {
      await _storage.write(key: _keyUsername, value: username);
      await _storage.write(key: _keyPassword, value: password);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> login(String username, String password) async {
    try {
      final savedUsername = await _storage.read(key: _keyUsername);
      final savedPassword = await _storage.read(key: _keyPassword);

      if (savedUsername == username && savedPassword == password) {
        await _storage.write(key: _keyIsLoggedIn, value: 'true');
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> logout() async {
    await _storage.delete(key: _keyIsLoggedIn);
  }

  @override
  Future<bool> checkAuthStatus() async {
     final isLoggedInStr = await _storage.read(key: _keyIsLoggedIn);
     return isLoggedInStr == 'true';
  }
  
  @override
   Future<String?> getCurrentUsername() async {
     return await _storage.read(key: _keyUsername);
   }
}