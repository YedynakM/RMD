import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:rmd_lab/data/repositories/i_music_repository.dart';


class FileExplorerPage extends StatefulWidget {
  const FileExplorerPage({super.key});

  @override
  State<FileExplorerPage> createState() => _FileExplorerPageState();
}

class _FileExplorerPageState extends State<FileExplorerPage> {
  bool _isLoading = false;
  String _statusMessage = 'Натисніть кнопку, щоб додати треки';

  Future<void> _pickAndImportFiles() async {
    PermissionStatus status;

    if (await Permission.audio.status.isDenied) {
     status = await Permission.audio.request();
  } else {
    status = await Permission.storage.request();
  }

    if (!status.isGranted && !status.isLimited) {
    setState(() => _statusMessage = 'Потрібен дозвіл на доступ до файлів!');
  
    if (status.isPermanentlyDenied) {
        openAppSettings();
    }
    return;
  }

    setState(() {
      _isLoading = true;
      _statusMessage = 'Відкриття провідника...';
    });

    try {

      final result = await FilePicker.platform.pickFiles(
        type: FileType.audio, 
        allowMultiple: true, 
      );

      if (result != null && result.files.isNotEmpty) {
        final musicRepo = Provider.of<IMusicRepository>(context, listen: false);
        int successCount = 0;

        setState(() => _statusMessage = 'Імпортування 0/${result.files.length}...');

        for (final file in result.files) {
          if (file.path != null) {
            final success = await musicRepo.importTrack(File(file.path!));
            if (success) successCount++;
            setState(() {
              _statusMessage = 'Імпортування $successCount/${result.files.length}...';
            });
          }
        }
        
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Успішно імпортовано $successCount з ${result.files.length} треків.')),
          );
        }

        if (context.mounted) Navigator.pop(context, true); 
        
      } else {
        setState(() => _statusMessage = 'Файли не вибрано.');
      }
    } catch (e) {
      setState(() => _statusMessage = 'Сталася помилка: $e');
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Імпорт файлів'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.file_upload_outlined, size: 100, color: Colors.deepPurple),
              const SizedBox(height: 30),
              if (_isLoading)
                const CircularProgressIndicator()
              else
                ElevatedButton.icon(
                  icon: const Icon(Icons.folder_open),
                  label: const Text('Вибрати аудіофайли'),
                  onPressed: _pickAndImportFiles, 
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                ),
              const SizedBox(height: 20),
              Text(
                _statusMessage, // Показуємо статус
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
