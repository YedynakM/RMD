import 'package:flutter/material.dart';
import '../widgets/custom_text_field.dart'; // Імпорт віджету

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 
              const Icon(Icons.music_note, size: 80, color: Colors.deepPurple),
              const SizedBox(height: 20),
              Text(
                "My Audio Hub",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 40),
              const CustomTextField(hintText: "Email", icon: Icons.email),
              const CustomTextField(
                hintText: "Пароль",
                icon: Icons.lock,
                isPassword: true,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  child: const Text("Увійти"),
                  onPressed: () {
                    // Навігація на головний екран, "замінюючи" цей
                    Navigator.pushReplacementNamed(context, '/home');
                  },
                ),
              ),
              TextButton(
                child: const Text("Немає акаунту? Зареєструватися"),
                onPressed: () {
                  Navigator.pushNamed(context, '/register');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}