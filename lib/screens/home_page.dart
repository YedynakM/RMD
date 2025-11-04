import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My audio collection"),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 
            // Картка для навігації до Списку Музики
            _buildHomeCard(
              context: context,
              icon: Icons.library_music,
              title: "Моя Бібліотека",
              subtitle: "Переглянути всі треки",
              routeName: '/all-music',
            ),
            const SizedBox(height: 16),
            // Картка для навігації до Провідника
            _buildHomeCard(
              context: context,
              icon: Icons.file_open,
              title: "Імпорт Файлів",
              subtitle: "Знайти нову музику на пристрої",
              routeName: '/explorer',
            ),
            const Spacer(),
            // Фейковий "міні-плеєр" внизу
            _buildMiniPlayer(context),
          ],
        ),
      ),
    );
  }

  // "приватний" віджет
  Widget _buildHomeCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required String routeName,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, routeName);
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            children: [
              Icon(icon, size: 40, color: Colors.deepPurple),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: Theme.of(context).textTheme.titleLarge),
                    Text(subtitle,
                        style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios),
            ],
          ),
        ),
      ),
    );
  }

  // Фейковий міні-плеєр
  Widget _buildMiniPlayer(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/player');
      },
      child: Card(
        color: Colors.deepPurple.withOpacity(0.5),
        child: const Padding(
          padding: EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.music_note),
                  SizedBox(width: 10),
                  Text("Зараз грає: Cool Fake Track (very cool)..."),
                ],
              ),
              Icon(Icons.play_arrow),
            ],
          ),
        ),
      ),
    );
  }
}