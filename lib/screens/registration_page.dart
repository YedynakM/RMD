import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/repositories/i_auth_repository.dart'; // Імпортуємо абстракцію
import '../core/validators.dart'; // Імпортуємо валідатори

// 1. Перетворюємо на StatefulWidget
class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  // 2. Створюємо контролери для отримання тексту з полів
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  
  // 3. Створюємо GlobalKey для валідації форми
  final _formKey = GlobalKey<FormState>();
  
  // 4. Локальний стан для показу завантаження
  bool _isLoading = false;

  @override
  void dispose() {
    // Не забуваємо очищувати контролери
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  // 5. Асинхронна функція для реєстрації
  Future<void> _register() async {
    // 6. Перевіряємо чи форма валідна
    if (_formKey.currentState?.validate() ?? false) {
      // Починаємо завантаження
      setState(() => _isLoading = true);

      // 7. Отримуємо репозиторій з Provider
      // listen: false - тому що нам не потрібно "слухати" зміни тут
      final authRepo = Provider.of<IAuthRepository>(context, listen: false);

      try {
        final success = await authRepo.register(
          _emailController.text,
          _passwordController.text,
          _usernameController.text,
        );

        if (success && mounted) { // 'mounted' перевіряє, чи віджет ще на екрані
          // Якщо успіх - перекидуємо на головну
          Navigator.pushReplacementNamed(context, '/home');
        }
      } catch (e) {
        // Обробка помилок
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Помилка реєстрації: $e')),
          );
        }
      }

      // Закінчуємо завантаження
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Реєстрація")),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          // 8. Додаємо Form для валідації
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Використовуємо TextFormField замість CustomTextField для валідації
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(hintText: "Ім'я", prefixIcon: Icon(Icons.person)),
                  validator: Validators.username, // Підключаємо валідатор
                  keyboardType: TextInputType.name,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(hintText: "Email", prefixIcon: Icon(Icons.email)),
                  validator: Validators.email, // Підключаємо валідатор
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(hintText: "Пароль", prefixIcon: Icon(Icons.lock)),
                  validator: Validators.password, // Підключаємо валідатор
                  obscureText: true,
                ),
                const SizedBox(height: 30),
                
                // 9. Показуємо або кнопку, або індикатор завантаження
                _isLoading
                    ? const CircularProgressIndicator()
                    : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _register, // Викликаємо нашу функцію
                          child: const Text("Зареєструватися"),
                        ),
                      ),
                TextButton(
                  child: const Text("Вже є акаунт? Увійти"),
                  onPressed: _isLoading ? null : () { // Блокуємо кнопку під час завантаження
                    Navigator.pop(context); 
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Примітка: Я замінив твій CustomTextField на TextFormField для легкої інтеграції валідації.
// Ти можеш "проапгрейдити" свій CustomTextField, щоб він приймав 'validator' 
// і використовував всередині себе TextFormField.