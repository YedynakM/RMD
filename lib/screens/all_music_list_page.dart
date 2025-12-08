import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rmd_lab/data/repositories/i_music_repository.dart';
import 'package:rmd_lab/models/track.dart';
import 'package:rmd_lab/widgets/music_track_tile.dart'; 

class AllMusicListPage extends StatefulWidget {
  const AllMusicListPage({super.key});

  @override
  State<AllMusicListPage> createState() => _AllMusicListPageState();
}

class _AllMusicListPageState extends State<AllMusicListPage> {

  late Future<List<Track>> _tracksFuture;
  var _sortType = TrackSortType.byDateAdded; 

  @override
  void initState() {
    super.initState();

    _loadTracks();
  }


  void _loadTracks() {

    final musicRepo = Provider.of<IMusicRepository>(context, listen: false);
    setState(() {

      _tracksFuture = musicRepo.getTracks(sort: _sortType);
    });
  }
  
  Future<void> _deleteTrack(Track track) async {
    final musicRepo = Provider.of<IMusicRepository>(context, listen: false);
    try {
      await musicRepo.deleteTrack(track);

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


  Future<void> _toggleFavorite(Track track) async {
    final musicRepo = Provider.of<IMusicRepository>(context, listen: false);
    try {

      await musicRepo.toggleFavorite(track.id!, !track.isFavorite);

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

          PopupMenuButton<TrackSortType>(
            icon: const Icon(Icons.sort),
            onSelected: (sortType) {
              setState(() {
                _sortType = sortType;
                _loadTracks(); 
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

      body: FutureBuilder<List<Track>>(
        future: _tracksFuture,
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Помилка завантаження треків: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Ваша бібліотека порожня.\nДодайте треки через сторінку "Імпорт файлів".',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          final tracks = snapshot.data!;

         return ListView.builder(
            itemCount: tracks.length,
            itemBuilder: (context, index) {
              final track = tracks[index];
              
              
              return Dismissible( 
                key: Key(track.id.toString()), 
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