import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:rmd_lab/data/repositories/i_music_repository.dart';

// Перетворюємо на StatefulWidget для керування станом завантаження
class FileExplorerPage extends StatefulWidget {
  const FileExplorerPage({super.key});

  @override
  State<FileExplorerPage> createState() => _FileExplorerPageState();
}

class _FileExplorerPageState extends State<FileExplorerPage> {
  bool _isLoading = false;
  String _statusMessage = 'Натисніть кнопку, щоб додати треки';

  // Функція для запиту дозволів та вибору файлів
  Future<void> _pickAndImportFiles() async {
    // 1. Запитуємо дозвіл на доступ до аудіофайлів (для Android 13+)
    // або до сховища (для старіших версій)
    var audioPermission = await Permission.audio.request();
    if (!audioPermission.isGranted) {
      // Якщо дозвіл не надано, запитуємо загальне сховище
      var storagePermission = await Permission.storage.request();
      if (!storagePermission.isGranted) {
        setState(() => _statusMessage = 'Дозвіл на доступ до файлів не надано');
        return;
      }
    }

    setState(() {
      _isLoading = true;
      _statusMessage = 'Відкриття провідника...';
    });

    try {
      // 2. Використовуємо FilePicker для вибору аудіофайлів
      final result = await FilePicker.platform.pickFiles(
        type: FileType.audio, // Фільтруємо лише аудіо
        allowMultiple: true, // Дозволяємо вибирати декілька
      );

      if (result != null && result.files.isNotEmpty) {
        final musicRepo = Provider.of<IMusicRepository>(context, listen: false);
        int successCount = 0;

        setState(() => _statusMessage = 'Імпортування 0/${result.files.length}...');

        // 3. Обробляємо кожен вибраний файл
        for (final file in result.files) {
          if (file.path != null) {
            final success = await musicRepo.importTrack(File(file.path!));
            if (success) successCount++;
            setState(() {
              _statusMessage = 'Імпортування $successCount/${result.files.length}...';
            });
          }
        }
        
        // 4. Показуємо результат в SnackBar
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Успішно імпортовано $successCount з ${result.files.length} треків.')),
          );
        }
        // Повертаємось на попередній екран
        if (context.mounted) Navigator.pop(context, true); 
        
      } else {
        // Користувач закрив провідник, не вибравши файл
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
      // 5. Будуємо UI
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
                  onPressed: _pickAndImportFiles, // Наша головна функція
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
