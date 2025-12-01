class Track {
  final int? id; // id з бази даних (може бути null, якщо ще не в базі)
  final String title;
  final String? artist;
  final String path; // Шлях до файлу в папці MyProgMusic
  final String format; // .mp3, .wav...
  final double sizeMb;
  final int durationMs; // Зберігатимемо в мілісекундах
  bool isFavorite;

  Track({
    this.id,
    required this.title,
    this.artist,
    required this.path,
    required this.format,
    required this.sizeMb,
    this.durationMs = 0, // За замовчуванням
    this.isFavorite = false,
  });

  // Метод для перетворення об'єкта Track в Map для запису в SQFLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'path': path,
      'format': format,
      'sizeMb': sizeMb,
      'durationMs': durationMs,
      // Перетворюємо bool в 0 або 1 для SQFLite
      'isFavorite': isFavorite ? 1 : 0, 
    };
  }

  // Метод для перетворення Map з SQFLite назад в об'єкт Track
  factory Track.fromMap(Map<String, dynamic> map) {
    return Track(
      // Явно приводимо типи за допомогою 'as'
      id: map['id'] as int?,
      title: map['title'] as String,
      artist: map['artist'] as String?,
      path: map['path'] as String,
      format: map['format'] as String,
      sizeMb: map['sizeMb'] as double,
      durationMs: map['durationMs'] as int,
      isFavorite: (map['isFavorite'] as int) == 1, // Тут лишаємо перевірку
    );
  }
}