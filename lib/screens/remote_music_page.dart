import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/home_provider.dart';

class RemoteMusicPage extends StatelessWidget {
  const RemoteMusicPage({super.key});

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
                   const Text("Немає з'єднання з брокером"),
                   TextButton(onPressed: provider.reconnectMqtt, child: const Text("Перепідключити"))
                 ],
               ),
             );
          }

          if (provider.remoteTracks.isEmpty) {
            return const Center(child: Text("Дані не отримано. Перевір Python скрипт."));
          }

          return ListView.builder(
            itemCount: provider.remoteTracks.length,
            itemBuilder: (context, index) {
              final track = provider.remoteTracks[index];
              return ListTile(
                leading: const Icon(Icons.computer, color: Colors.deepPurpleAccent),
                title: Text(track.title),
                subtitle: Text("${track.sizeMb} MB"),
                trailing: const Icon(Icons.cloud_download_outlined),
              );
            },
          );
        },
      ),
    );
  }
}