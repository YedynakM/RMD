import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/home_provider.dart';
import '../models/remote_track.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final homeProvider = context.watch<HomeProvider>();
    final tracks = homeProvider.remoteTracks; 

    return Scaffold(
      appBar: AppBar(
        title: Text('Привіт, ${authProvider.currentUsername ?? "User"}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.library_music),
            tooltip: "Локальна бібліотека",
            onPressed: () => Navigator.pushNamed(context, '/all-music'),
          ),
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () => _showLogoutDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          if (authProvider.isOffline)
            Container(
              color: Colors.redAccent,
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              child: const Text(
                'Офлайн режим. Дані можуть бути неактуальні.',
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          if (!homeProvider.isMqttConnected && !authProvider.isOffline)
            Container(
              color: Colors.orangeAccent,
              padding: const EdgeInsets.all(4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Підключення до MQTT..."),
                  const SizedBox(width: 10),
                  IconButton(
                      onPressed: homeProvider.reconnectMqtt,
                      icon: const Icon(Icons.refresh))
                ],
              ),
            ),
          
          // Заголовок списку
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text("Музика на ПК (MQTT):", 
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey))
            ),
          ),

          Expanded(
            child: homeProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : tracks.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.cloud_off, size: 60, color: Colors.grey),
                            Text('Немає треків з ПК'),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: tracks.length,
                        itemBuilder: (context, index) {
                          final track = tracks[index];
                          return _buildTrackCard(track); 
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrackCard(RemoteTrack track) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      elevation: 2,
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.deepPurple,
          child: Icon(Icons.computer, color: Colors.white),
        ),
        title: Text(track.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('${track.artist} • ${track.sizeMb} MB'),
        trailing: IconButton(
          icon: const Icon(Icons.download_rounded),
          onPressed: () {
            // Тут буде логіка завантаження пізніше
          },
        ),
      ),
    );
  }

  Future<void> _showLogoutDialog(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Вихід'),
        content: const Text('Ви впевнені, що хочете вийти з облікового запису?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Скасувати'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Вийти'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await context.read<AuthProvider>().logout();
    }
  }
}