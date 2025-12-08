import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:rmd_lab/data/database/app_database.dart';
import 'package:rmd_lab/data/repositories/i_music_repository.dart';
import 'package:rmd_lab/models/track.dart';
import 'package:sqflite/sqflite.dart';


class LocalMusicRepository implements IMusicRepository {
  final dbProvider = AppDatabase.instance;
  final String _appMusicFolder = 'MyProgMusic'; 
  
  Future<Directory> _getAppMusicDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    final musicDir = Directory(p.join(appDir.path, _appMusicFolder));

    if (!await musicDir.exists()) {// ignore: avoid_slow_async_io
      await musicDir.create(recursive: true); 
    }
    
    return musicDir;
  }

  @override
  Future<bool> importTrack(File file) async {
    try {
      final musicDir = await _getAppMusicDirectory();
      final newPath = p.join(musicDir.path, p.basename(file.path));


      final newFile = await file.copy(newPath); 


      final fileStat = await newFile.stat();
      final title = p.basenameWithoutExtension(newFile.path);
      final format = p.extension(newFile.path);
      final sizeMb = fileStat.size / (1024 * 1024);
      
      // TODO: Отримати справжню тривалість та артиста

      final durationMs = 0; 
      final artist = 'Unknown Artist';

      final track = Track(
        title: title,
        artist: artist,
        path: newFile.path,
        format: format,
        sizeMb: sizeMb,
        durationMs: durationMs,
      );

      final db = await dbProvider.database;
      await db.insert(
        AppDatabase.trackTable,
        track.toMap(),
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
        orderBy = 'id DESC'; 
        break; 
    }

    final List<Map<String, dynamic>> maps = await db.query(
      AppDatabase.trackTable,
      orderBy: orderBy,
    );

    return List.generate(maps.length, (i) => Track.fromMap(maps[i]));
  }

  @override
  Future<List<Track>> getFavoriteTracks() async {
    final db = await dbProvider.database;
    final List<Map<String, dynamic>> maps = await db.query(
      AppDatabase.trackTable,
      where: 'isFavorite = ?',
      whereArgs: [1], 
      orderBy: 'title ASC',
    );
    return List.generate(maps.length, (i) => Track.fromMap(maps[i]));
  }

  @override
  Future<void> toggleFavorite(int trackId, bool isFavorite) async {
    final db = await dbProvider.database;
    await db.update(
      AppDatabase.trackTable,
      {'isFavorite': isFavorite ? 1 : 0}, 
      where: 'id = ?',
      whereArgs: [trackId],
    );
  }
  
  @override
  Future<void> deleteTrack(Track track) async {
    final db = await dbProvider.database;
    
    await db.delete(
      AppDatabase.trackTable,
      where: 'id = ?',
      whereArgs: [track.id],
    );
    
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