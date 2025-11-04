import 'package:flutter/material.dart';
import '../widgets/custom_text_field.dart'; 

class RegistrationPage extends StatelessWidget {
  const RegistrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Реєстрація")),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CustomTextField(hintText: "Email", icon: Icons.email),
              const CustomTextField(
                hintText: "Пароль",
                icon: Icons.lock,
                isPassword: true,
              ),
              const CustomTextField(
                hintText: "Повторіть пароль",
                icon: Icons.lock_outline,
                isPassword: true,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  child: const Text("Зареєструватися"),
                  onPressed: () {
                    // Логіки немає (і не буде), перекидуємо на головну
                    Navigator.pushReplacementNamed(context, '/home');
                  },
                ),
              ),
              TextButton(
                child: const Text("Вже є акаунт? Увійти"),
                onPressed: () {
                  Navigator.pop(context); // Повертаємось назад
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}