import 'package:flutter/material.dart';

class FileExplorerPage extends StatelessWidget {
  const FileExplorerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Імпорт файлів"),
      ),
      body: ListView(
        children: [
          // Фейкові папки
          const ListTile(
            leading: Icon(Icons.folder, color: Colors.amber),
            title: Text("Downloads"),
          ),
          const ListTile(
            leading: Icon(Icons.folder, color: Colors.blue),
            title: Text("Telegram Documents"),
          ),
          const Divider(),
          // Фейкові файли (все це брехня)
          ListTile(
            leading: const Icon(Icons.audio_file, color: Colors.grey),
            title: const Text("cool_song_from_chrome.mp3"),
            trailing: Checkbox(value: false, onChanged: (v) {}),
          ),
          ListTile(
            leading: const Icon(Icons.audio_file, color: Colors.grey),
            title: const Text("voice_message_123.ogg"),
            trailing: Checkbox(value: true, onChanged: (v) {}),
          ),
          ListTile(
            leading: const Icon(Icons.audio_file, color: Colors.grey),
            title: const Text("my_super_track.wav"),
            trailing: Checkbox(value: false, onChanged: (v) {}),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              child: const Text("Імпортувати вибране (2)"),
              onPressed: () {
                // Нічого не робимо, (не)просто візуал
                Navigator.pop(context); // Повертаємось назад
              },
            ),
          )
        ],
      ),
    );
  }
}