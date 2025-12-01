import 'dart:io';
import 'package:rmd_lab/models/track.dart';

// Перерахування для сортування
enum TrackSortType { byTitle, byDateAdded, bySize }

abstract class IMusicRepository {
  // Метод для імпорту: переміщує файл і додає в БД
  Future<bool> importTrack(File file);

  // Отримує всі треки з БД
  Future<List<Track>> getTracks(
    {TrackSortType sort = TrackSortType.byDateAdded});

  // Отримує тільки улюблені треки
  Future<List<Track>> getFavoriteTracks();

  // Перемикає статус "улюблене" для треку
  Future<void> toggleFavorite(int trackId, bool isFavorite);

  // Видаляє трек (і з БД, і файл)
  Future<void> deleteTrack(Track track);
}
