import 'package:flutter/material.dart';

class PlayerPage extends StatelessWidget {
  const PlayerPage({super.key});

  @override
  Widget build(BuildContext context) {
    // MediaQuery використовуємо для адаптивності
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit), // Кнопка "Редагувати"
            onPressed: () {
              // Логіка перейменування (треба буде зробити)
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
            // 
            //  Обкладинка альбому
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
            const Text(
              "Назва Фейкового Треку",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Ім'я Виконавця",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            // Фейковий слайдер прогресу
            Slider(
              value: 0.3, //  30%
              onChanged: (value) {
                // Логіки немає
              },
              activeColor: Colors.deepPurple,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("1:02"),
                Text("3:45"),
              ],
            ),
            const Spacer(),
            // Кнопки управління світом
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