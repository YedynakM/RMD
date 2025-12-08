import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart'; 
import '../providers/home_provider.dart';


class RemoteMusicPage extends StatelessWidget {
  const RemoteMusicPage({super.key});

  final String _baseUrl = 'http://10.0.2.2:5000/download';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Музика з ПК (MQTT)")),
      body: Consumer<HomeProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!provider.isMqttConnected) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.wifi_off, size: 50, color: Colors.red),
                  const SizedBox(height: 10),
                  const Text("Немає з'єднання з брокером"),
                  TextButton(
                    onPressed: provider.reconnectMqtt,
                    child: const Text("Перепідключити"),
                  )
                ],
              ),
            );
          }


          if (provider.remoteTracks.isEmpty) {
            return const Center(child: Text("Список пустий. Перевірте Python скрипт."));
          }


          return ListView.builder(
            itemCount: provider.remoteTracks.length,
            itemBuilder: (context, index) {
              final track = provider.remoteTracks[index];
              
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ListTile(
                  leading: const Icon(Icons.music_note, color: Colors.deepPurple),
                  title: Text(
                    track.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text('${track.sizeMb} MB'),
                  

                  trailing: IconButton(
                    icon: const Icon(Icons.link, color: Colors.green),
                    tooltip: "Отримати посилання",
                    onPressed: () {
                      _showDownloadDialog(context, track.title);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
  void _showDownloadDialog(BuildContext context, String filename) {
  final encodedName = Uri.encodeComponent(filename);
  final urlString = '$_baseUrl/$encodedName';
  final uri = Uri.parse(urlString);

  WidgetsBinding.instance.addPostFrameCallback((_) {
    showDialog<void>(
      context: context,
      barrierDismissible: true, // Дозволити закриття при тапі поза діалогом
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Скачати трек"),
          content: Text("Створити посилання для: $filename?"),
          actions: <Widget>[
            TextButton(
              child: const Text('Скасувати'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Скопіювати посилання'),
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: urlString));
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Посилання скопійовано!")),
                  );
                  Navigator.of(context).pop();
                }
              },
            ),
            ElevatedButton(
              child: const Text('Відкрити в браузері'),
              onPressed: () async {
                try {
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri);
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Помилка: $e')),
                    );
                  }
                } finally {
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                }
              },
            ),
          ],
        );
      },
    );
  });
} 
}
