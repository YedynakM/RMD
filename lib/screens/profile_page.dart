import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rmd_lab/data/repositories/i_auth_repository.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Отримуємо репозиторій. 'listen: false' бо нам не треба слухати зміни.
    final authRepo = Provider.of<IAuthRepository>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Профіль')),
      // FutureBuilder - ідеальний для завантаження даних, які не змінюються
      body: FutureBuilder<Map<String, String?>>(
        // 1. Викликаємо метод, який повертає Future
        future: authRepo.getUserData(),
        // 2. 'builder' будує UI в залежності від стану Future
        builder: (context, snapshot) {
          // 3. Поки дані завантажуються, показуємо індикатор
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 4. Якщо сталася помилка
          if (snapshot.hasError) {
            return Center(child: Text('Помилка завантаження даних: ${snapshot.error}'));
          }

          // 5. Якщо дані успішно завантажені
          if (snapshot.hasData) {
            final userData = snapshot.data!;
            final email = userData['email'] ?? 'Email не знайдено';
            final username = userData['username'] ?? 'Ім\'я не знайдено';

            // Показуємо реальні дані
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.deepPurple,
                    child: Text(
                      // Перша буква імені, якщо воно є
                      username.isNotEmpty ? username[0].toUpperCase() : '?',
                      style: const TextStyle(fontSize: 40, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(username, style: const TextStyle(fontSize: 24)),
                  const SizedBox(height: 10),
                  Text(email, style: const TextStyle(color: Colors.grey)),
                  const Divider(height: 40),
                  const ListTile(
                    leading: Icon(Icons.folder_special),
                    title: Text('Папка бібліотеки'),
                    subtitle: Text('/MyProgMusic/'),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: const Text('Вийти'),
                      // 6. Додаємо логіку виходу
                      onPressed: () async {
                        await authRepo.logout();
                        if (context.mounted) {
                          Navigator.pushNamedAndRemoveUntil(
                              context, '/login', (route) => false);
                        }
                      },
                    ),
                  ),
                ],
              ),
            );
          }
          
          // Якщо даних немає (хоча не має бути)
          return const Center(child: Text('Дані користувача не знайдено.'));
        },
      ),
    );
  }
}
