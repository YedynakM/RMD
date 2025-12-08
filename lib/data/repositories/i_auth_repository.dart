abstract class IAuthRepository {

  Future<bool> register(String username, String password);

  Future<bool> login(String username, String password);

  Future<void> logout();

  Future<bool> checkAuthStatus();
  
  Future<String?> getCurrentUsername();
  
}