import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rmd_lab/data/repositories/i_music_repository.dart';
import 'package:rmd_lab/models/track.dart';
import 'package:rmd_lab/widgets/music_track_tile.dart'; 

// Перетворюємо на StatefulWidget, щоб керувати станом завантаження/сортування
class AllMusicListPage extends StatefulWidget {
  const AllMusicListPage({super.key});

  @override
  State<AllMusicListPage> createState() => _AllMusicListPageState();
}

class _AllMusicListPageState extends State<AllMusicListPage> {
  // 'late' означає, що ми ініціалізуємо цю змінну трохи пізніше (в initState)
  late Future<List<Track>> _tracksFuture;
  var _sortType = TrackSortType.byDateAdded; // Стан сортування

  @override
  void initState() {
    super.initState();
    // Завантажуємо треки при першому відкритті сторінки
    _loadTracks();
  }

  // Функція для завантаження або перезавантаження треків
  void _loadTracks() {
    // Отримуємо репозиторій з Provider
    final musicRepo = Provider.of<IMusicRepository>(context, listen: false);
    setState(() {
      // 1. Зберігаємо Future в змінну стану
      _tracksFuture = musicRepo.getTracks(sort: _sortType);
    });
  }
  
  // Функція для видалення треку
  Future<void> _deleteTrack(Track track) async {
    final musicRepo = Provider.of<IMusicRepository>(context, listen: false);
    try {
      await musicRepo.deleteTrack(track);
      // Після успішного видалення - перезавантажуємо список
      _loadTracks(); 
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Трек "${track.title}" видалено')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Не вдалося видалити трек: $e')),
        );
      }
    }
  }

  // Функція для "улюблених"
  Future<void> _toggleFavorite(Track track) async {
    final musicRepo = Provider.of<IMusicRepository>(context, listen: false);
    try {
      // Перемикаємо статус
      await musicRepo.toggleFavorite(track.id!, !track.isFavorite);
      // Перезавантажуємо список, щоб побачити зміни
      _loadTracks(); 
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Не вдалося оновити статус: $e')),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Моя Бібліотека'),
        actions: [
          // 2. Меню для сортування
          PopupMenuButton<TrackSortType>(
            icon: const Icon(Icons.sort),
            onSelected: (sortType) {
              setState(() {
                _sortType = sortType;
                _loadTracks(); // Перезавантажуємо з новим сортуванням
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: TrackSortType.byDateAdded,
                child: Text('За датою додавання'),
              ),
              const PopupMenuItem(
                value: TrackSortType.byTitle,
                child: Text('За назвою (A-Z)'),
              ),
              const PopupMenuItem(
                value: TrackSortType.bySize,
                child: Text('За розміром'),
              ),
            ],
          )
        ],
      ),
      // 3. Використовуємо FutureBuilder для відображення списку
      body: FutureBuilder<List<Track>>(
        future: _tracksFuture,
        builder: (context, snapshot) {
          // Поки дані завантажуються
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // Якщо помилка
          if (snapshot.hasError) {
            return Center(child: Text('Помилка завантаження треків: ${snapshot.error}'));
          }
          // Якщо дані є, але список порожній
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Ваша бібліотека порожня.\nДодайте треки через сторінку "Імпорт файлів".',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          // 4. Дані завантажено, будуємо список
          final tracks = snapshot.data!;

         return ListView.builder(
            itemCount: tracks.length,
            itemBuilder: (context, index) {
              final track = tracks[index];
              
              
              return Dismissible( 
                key: Key(track.id.toString()), // Унікальний ключ
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (direction) {
                  _deleteTrack(track);
                },
                child: MusicTrackTile(
                  track: track,
                  onPlay: () {
                    Navigator.pushNamed(context, '/player', arguments: track);
                  },
                  onToggleFavorite: () {
                    _toggleFavorite(track);
                    
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}