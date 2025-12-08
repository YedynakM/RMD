import 'package:flutter/material.dart';
import 'package:rmd_lab/models/track.dart'; 

class PlayerPage extends StatelessWidget {
  const PlayerPage({super.key});

  @override
  Widget build(BuildContext context) {

    final track = ModalRoute.of(context)!.settings.arguments as Track?;
    
    final screenSize = MediaQuery.of(context).size;

    final title = track?.title ?? "Назва Треку";
    final artist = track?.artist ?? "Виконавець";
    final durationMs = track?.durationMs ?? 0;
    

    String formatDuration(int ms) {
      if (ms <= 0) return "--:--";
      final duration = Duration(milliseconds: ms);
      final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
      final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
      return '$minutes:$seconds';
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit), 
            onPressed: () {

            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            
            Container(
              width: screenSize.width * 0.7,
              height: screenSize.width * 0.7,
              decoration: BoxDecoration(
                color: Colors.grey.shade800,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.music_note,
                  size: 100, color: Colors.white54),
            ),
            const SizedBox(height: 40),
            

            Text(
              title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
              maxLines: 2, 
            ),
            const SizedBox(height: 8),
            Text(
              artist,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            

            Slider(
              value: 0.3, 
              onChanged: (value) {

              },
              activeColor: Colors.deepPurple,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("1:02"), // TODO: 'Поточний час'
                Text(formatDuration(durationMs)), 
              ],
            ),
            const Spacer(),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.shuffle), // Перемішка
                  iconSize: 32,
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.skip_previous), // Попередній
                  iconSize: 48,
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.play_circle_fill), // Play/Pause
                  iconSize: 72,
                  color: Colors.deepPurple,
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.skip_next), // Наступний
                  iconSize: 48,
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.repeat), // Повтор
                  iconSize: 32,
                  onPressed: () {},
                ),
              ],
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
