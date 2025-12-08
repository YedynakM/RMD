import 'package:flutter/material.dart';
import 'package:rmd_lab/models/track.dart'; 

class MusicTrackTile extends StatelessWidget {

  final Track track; 
  final VoidCallback onPlay;
  final VoidCallback onToggleFavorite; 

  const MusicTrackTile({
    super.key,
    required this.track,
    required this.onPlay,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
 
    String formatDuration(int ms) {
      if (ms <= 0) return "--:--";
      final duration = Duration(milliseconds: ms);
      final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
      final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
      return '$minutes:$seconds';
    }

    return ListTile(
      leading: const CircleAvatar(
        backgroundColor: Colors.deepPurple,
        child: Icon(Icons.music_note, color: Colors.white),
      ),

      title: Text(track.title, style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 1),
      subtitle: Text(
        '${track.artist ?? "Невідомий"} • ${track.sizeMb.toStringAsFixed(1)} MB',
        maxLines: 1,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min, 
        children: [
          Text(formatDuration(track.durationMs)),

          IconButton(
            icon: Icon(
              track.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: track.isFavorite ? Colors.redAccent : Colors.grey,
            ),
            onPressed: onToggleFavorite,
          ),
        ],
      ),
      onTap: onPlay, 
    );
  }
}
