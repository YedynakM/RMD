import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:rmd_lab/core/validators.dart';
import 'package:rmd_lab/data/repositories/i_auth_repository.dart';


// 1. Перетворюємо на StatefulWidget
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // 2. Контролери, ключ форми, стан завантаження
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _errorMessage; // Для показу помилок логіну

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // 3. Асинхронна функція для логіну
  Future<void> _login() async {
    // Скидуємо попередню помилку
    setState(() => _errorMessage = null);

    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);

      final authRepo = Provider.of<IAuthRepository>(context, listen: false);

      try {
        final success = await authRepo.login(
          _emailController.text,
          _passwordController.text,
        );

        if (success && mounted) {
          // Успіх - перекидуємо на головну
          Navigator.pushReplacementNamed(context, '/home');
        } else if (!success && mounted) {
          // Провал - показуємо помилку
          setState(() => _errorMessage = 'Неправильний email чи пароль');
        }
      } catch (e) {
        if (mounted) {
          setState(() => _errorMessage = 'Сталася помилка. Спробуйте пізніше.');
        }
      }

      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          // 4. Форма
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction, 
            //кароч був баг, якщо ввести пароль не правильний, 
            //то ввід будь якого паролю, навіть правильного тупо
            //вважався хибним, і треба було акаунт заново створювати
            //кароч позор, який мав би пофікситися фігньою зверху
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.music_note, size: 80, color: Colors.deepPurple),
                const SizedBox(height: 20),
                Text(
                  "My Audio Hub",
                  style: Theme.of(context).textTheme.headlineSmall,
                ), 
                const SizedBox(height: 40),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(hintText: "Email", prefixIcon: Icon(Icons.email)),
                  validator: Validators.email,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(hintText: "Пароль", prefixIcon: Icon(Icons.lock)),
                  validator: Validators.password,
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                
                // 5. Показ помилки, якщо вона є
                if (_errorMessage != null)
                  Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red, fontSize: 14),
                  ),
                
                const SizedBox(height: 20),
                
                // 6. Кнопка або завантаження
                _isLoading
                    ? const CircularProgressIndicator()
                    : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _login, // Викликаємо логін
                          child: const Text("Увійти"),
                        ),
                      ),
                TextButton(
                  child: const Text("Немає акаунту? Зареєструватися"),
                  onPressed: _isLoading ? null : () {
                    Navigator.pushNamed(context, '/register');
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