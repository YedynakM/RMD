import 'package:flutter/material.dart';

class MusicTrackTile extends StatelessWidget {
  final String title;
  final String artist;
  final VoidCallback onPlay;

  const MusicTrackTile({
    super.key,
    required this.title,
    required this.artist,
    required this.onPlay,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(
        backgroundColor: Colors.deepPurple,
        child: Icon(Icons.music_note, color: Colors.white),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(artist),
      trailing: IconButton(
        icon: const Icon(Icons.play_arrow),
        onPressed: onPlay,
      ),
      onTap: onPlay, // Клікабельний весь рядок
    );
  }
}