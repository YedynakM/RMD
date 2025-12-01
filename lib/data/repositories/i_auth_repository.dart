// інтерфейс
abstract class IAuthRepository {
  // Метод для реєстрації
  Future<bool> register(String email, String password, String username);

  // Метод для логіну
  Future<bool> login(String email, String password);

  // Метод для виходу
  Future<void> logout();

  // Метод, щоб отримати дані користувача
  // (Ми повернемо Map, де ключ - це 'email' або 'username')
  Future<Map<String, String?>> getUserData();
}
