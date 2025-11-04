import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Профіль")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.deepPurple,
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 20),
            const Text("Demo Men tf2", style: TextStyle(fontSize: 24)),
            const SizedBox(height: 10),
            const Text("demo@user.com", style: TextStyle(color: Colors.grey)),
            const Divider(height: 40),
            const ListTile(
              leading: Icon(Icons.folder_open),
              title: Text("Папка імпорту"),
              subtitle: Text("/Downloads/"),
            ),
            const ListTile(
              leading: Icon(Icons.folder_special),
              title: Text("Папка бібліотеки"),
              subtitle: Text("/MyAudioHub/"),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text("Вийти(З вікна)"),
                onPressed: () {
                  // Виходимо і повертаємось на логін, чистячи всі екрани
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/login', (route) => false);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}