class Track {
  final int? id; 
  final String title;
  final String? artist;
  final String path;
  final String format; 
  final double sizeMb;
  final int durationMs;
  bool isFavorite;

  Track({
    this.id,
    required this.title,
    this.artist,
    required this.path,
    required this.format,
    required this.sizeMb,
    this.durationMs = 0,
    this.isFavorite = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'path': path,
      'format': format,
      'sizeMb': sizeMb,
      'durationMs': durationMs,
      'isFavorite': isFavorite ? 1 : 0, 
    };
  }


  factory Track.fromMap(Map<String, dynamic> map) {
    return Track(

      id: map['id'] as int?,
      title: map['title'] as String,
      artist: map['artist'] as String?,
      path: map['path'] as String,
      format: map['format'] as String,
      sizeMb: map['sizeMb'] as double,
      durationMs: map['durationMs'] as int,
      isFavorite: (map['isFavorite'] as int) == 1,
    );
  }
}