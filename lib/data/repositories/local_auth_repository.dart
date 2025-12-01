import 'package:rmd_lab/data/repositories/i_auth_repository.dart'; // Імпортуємо наш "контракт"
import 'package:shared_preferences/shared_preferences.dart';


// Цей клас РЕАЛІЗУЄ (implements) наш інтерфейс
class LocalAuthRepository implements IAuthRepository {
  
  // Ключі для збереження в SharedPreferences
  static const String _emailKey = 'user_email';
  static const String _passwordKey = 'user_password';
  static const String _usernameKey = 'user_username';

  @override
  Future<bool> register(String email, String password, String username) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Зберігаємо дані (в реальному житті пароль треба хешувати!)
    await prefs.setString(_emailKey, email);
    await prefs.setString(_passwordKey, password);
    await prefs.setString(_usernameKey, username);
    
    print('User registered: $email'); // Для дебагу
    return true; // Повертаємо успіх
  }

  @override
  Future<bool> login(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Отримуємо збережені дані
    final savedEmail = prefs.getString(_emailKey);
    final savedPassword = prefs.getString(_passwordKey);
    
    // Звіряємо дані
    if (savedEmail == email && savedPassword == password) {
      print('Login successful: $email'); // Для дебагу
      return true;
    }
    
    print('Login failed'); // Для дебагу
    return false; // Повертаємо провал
  }

  @override
  Future<Map<String, String?>> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString(_emailKey);
    final username = prefs.getString(_usernameKey);
    
    return {
      'email': email,
      'username': username,
    };
  }
  
  @override
  Future<void> logout() async {
     final prefs = await SharedPreferences.getInstance();
     // В Lab 3 це не вимагається, але логічно просто очистити ключі
     await prefs.remove(_emailKey);
     await prefs.remove(_passwordKey);
     await prefs.remove(_usernameKey);
     print('User logged out');
  }
}
