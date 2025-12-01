import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  // Назва нашої таблиці
  static const String trackTable = 'tracks';

  // Робимо клас Singleton, щоб мати лише одне підключення до БД
  AppDatabase._privateConstructor();
  static final AppDatabase instance = AppDatabase._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Ініціалізація (створення) бази даних
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'music_hub.db'); // Назва файлу БД
    
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate, // Ця функція виконається при першому створенні БД
    );
  }

  // Створюємо структуру таблиці "tracks"
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $trackTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        artist TEXT,
        path TEXT NOT NULL UNIQUE, 
        format TEXT NOT NULL,
        sizeMb REAL NOT NULL,
        durationMs INTEGER NOT NULL,
        isFavorite INTEGER NOT NULL DEFAULT 0 
      )
    ''');
  }
}
