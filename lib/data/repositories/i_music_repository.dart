import 'dart:io';
import 'package:rmd_lab/models/track.dart';

enum TrackSortType { byTitle, byDateAdded, bySize }

abstract class IMusicRepository {

  Future<bool> importTrack(File file);

  Future<List<Track>> getTracks(
    {TrackSortType sort = TrackSortType.byDateAdded});

  Future<List<Track>> getFavoriteTracks();

  Future<void> toggleFavorite(int trackId, bool isFavorite);

  Future<void> deleteTrack(Track track);
  
}
