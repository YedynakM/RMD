import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rmd_lab/data/repositories/i_auth_repository.dart';
import 'package:rmd_lab/providers/auth_provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authRepo = Provider.of<IAuthRepository>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text("Профіль")),
      body: FutureBuilder<String?>(
        future: authRepo.getCurrentUsername(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Помилка: ${snapshot.error}"));
          }

          final username = snapshot.data ?? 'Користувач';

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.deepPurple,
                  child: Text(
                    username.isNotEmpty ? username[0].toUpperCase() : '?',
                    style: const TextStyle(fontSize: 40, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20),
                Text(username, style: const TextStyle(fontSize: 24)),
                const SizedBox(height: 10),
                const Text("Auth Type: Secure Storage", style: TextStyle(color: Colors.grey)),
                const Divider(height: 40),
                const ListTile(
                  leading: Icon(Icons.folder_special),
                  title: Text("Папка бібліотеки"),
                  subtitle: Text("/MyProgMusic/"),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text("Вийти"),
                    onPressed: () async {
                      await context.read<AuthProvider>().logout();
                      if (context.mounted) {
                         Navigator.popUntil(context, (route) => route.isFirst);
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
