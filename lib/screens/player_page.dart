import 'package:flutter/material.dart';
import 'package:rmd_lab/models/track.dart'; // Імпортуємо модель

class PlayerPage extends StatelessWidget {
  const PlayerPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Отримуємо об'єкт Track, який ми передали через 'arguments'
    final track = ModalRoute.of(context)!.settings.arguments as Track?;
    
    // Повертаємо твій 'MediaQuery' для адаптивності
    final screenSize = MediaQuery.of(context).size;

    // 2. Якщо трек не передано, показуємо дані за замовчуванням
    final title = track?.title ?? "Назва Треку";
    final artist = track?.artist ?? "Виконавець";
    final durationMs = track?.durationMs ?? 0;
    
    // Функція для форматування тривалості
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
            icon: const Icon(Icons.edit), // Кнопка "Редагувати"
            onPressed: () {
              // Тут буде логіка перейменування
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
            
            // [Image of an album cover]



            // Твій контейнер для обкладинки
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
            
            // 3. Використовуємо реальні дані
            Text(
              title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
              maxLines: 2, // На випадок довгих назв
            ),
            const SizedBox(height: 8),
            Text(
              artist,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            
            // Твій слайдер
            Slider(
              value: 0.3, // "нібито" на 30%
              onChanged: (value) {
                // Логіки немає
              },
              activeColor: Colors.deepPurple,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("1:02"), // TODO: 'Поточний час'
                Text(formatDuration(durationMs)), // 4. Реальна тривалість
              ],
            ),
            const Spacer(),
            
            // Твої кнопки управління
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
