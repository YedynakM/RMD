import 'package:flutter/material.dart';
import '../widgets/music_track_tile.dart'; 

class AllMusicListPage extends StatelessWidget {
  const AllMusicListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Моя Бібліотека"),
      ),
      // Використовуємо ListView.builder для списків
      body: ListView.builder(
        itemCount: 20, // Фейкова кількість треків(недостатньо)
        itemBuilder: (context, index) {
          return MusicTrackTile(
            title: "Трек ${index + 1}",
            artist: "Виконавець ${index + 1}",
            onPlay: () {
              // Перехід на плеєр
              Navigator.pushNamed(context, '/player');
            },
          );
        },
      ),
    );
  }
}