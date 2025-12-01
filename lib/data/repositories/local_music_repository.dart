import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:rmd_lab/data/database/app_database.dart';
import 'package:rmd_lab/data/repositories/i_music_repository.dart';
import 'package:rmd_lab/models/track.dart';
import 'package:sqflite/sqflite.dart';


class LocalMusicRepository implements IMusicRepository {
  final dbProvider = AppDatabase.instance;
  final String _appMusicFolder = 'MyProgMusic'; // Твоя папка!

  // Приватна функція для отримання нашої папки
  Future<Directory> _getAppMusicDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    final musicDir = Directory(p.join(appDir.path, _appMusicFolder));

    if (!await musicDir.exists()) {// ignore: avoid_slow_async_io
      await musicDir.create(recursive: true); // Створюємо, якщо не існує
    }
    
    return musicDir;
  }

  @override
  Future<bool> importTrack(File file) async {
    try {
      final musicDir = await _getAppMusicDirectory();
      final newPath = p.join(musicDir.path, p.basename(file.path));

      // 1. Копіюємо (або переміщуємо) файл у папку додатка
      // Використовуємо copy, бо move може не спрацювати між різними "дисками"
      final newFile = await file.copy(newPath); 

      // 2. Збираємо інформацію про файл
      final fileStat = await newFile.stat();// ignore: avoid_slow_async_io
      final title = p.basenameWithoutExtension(newFile.path);
      final format = p.extension(newFile.path);
      final sizeMb = fileStat.size / (1024 * 1024);
      
      // TODO: Отримати справжню тривалість та артиста
      // Поки що не реалізовано, це складніша логіка
      final durationMs = 0; 
      final artist = 'Unknown Artist';

      // 3. Створюємо об'єкт Track
      final track = Track(
        title: title,
        artist: artist,
        path: newFile.path,
        format: format,
        sizeMb: sizeMb,
        durationMs: durationMs,
      );

      // 4. Записуємо в Базу Даних
      final db = await dbProvider.database;
      await db.insert(
        AppDatabase.trackTable,
        track.toMap(),
        // UNIQUE на 'path' попіклується про дублікати
        conflictAlgorithm: ConflictAlgorithm.ignore, 
      );
      return true;
    } catch (e) {
      print("Помилка імпорту треку: $e");
      return false;
    }
  }

  @override
  Future<List<Track>> getTracks(
      {TrackSortType sort = TrackSortType.byDateAdded}) async {
        
    final db = await dbProvider.database;
    String orderBy;

    switch (sort) {
      case TrackSortType.byTitle:
        orderBy = 'title ASC';
        break;
      case TrackSortType.bySize:
        orderBy = 'sizeMb DESC';
        break;
      case TrackSortType.byDateAdded:
        orderBy = 'id DESC'; // Новіші - перші
        break; // Додаємо 'break' сюди
    }

    final List<Map<String, dynamic>> maps = await db.query(
      AppDatabase.trackTable,
      orderBy: orderBy,
    );

    // Перетворюємо список Map в список Track
    return List.generate(maps.length, (i) => Track.fromMap(maps[i]));
  }

  @override
  Future<List<Track>> getFavoriteTracks() async {
    final db = await dbProvider.database;
    final List<Map<String, dynamic>> maps = await db.query(
      AppDatabase.trackTable,
      where: 'isFavorite = ?',
      whereArgs: [1], // Шукаємо, де isFavorite = 1
      orderBy: 'title ASC',
    );
    return List.generate(maps.length, (i) => Track.fromMap(maps[i]));
  }

  @override
  Future<void> toggleFavorite(int trackId, bool isFavorite) async {
    final db = await dbProvider.database;
    await db.update(
      AppDatabase.trackTable,
      {'isFavorite': isFavorite ? 1 : 0}, // Нове значення
      where: 'id = ?',
      whereArgs: [trackId],
    );
  }
  
  @override
  Future<void> deleteTrack(Track track) async {
    final db = await dbProvider.database;
    
    // 1. Видаляємо з БД
    await db.delete(
      AppDatabase.trackTable,
      where: 'id = ?',
      whereArgs: [track.id],
    );
    
    // 2. Видаляємо файл з папки MyProgMusic
    try {
      final file = File(track.path);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      print("Не вдалося видалити файл: $e");
    }
  }
}