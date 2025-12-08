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
    setState(() {
      _tracksFuture = Provider.of<IMusicRepository>(context, listen: false).getTracks(sort: _sortType);
    });
  }

  Future<void> _deleteTrack(Track track) async {
    try {
      await context.read<IMusicRepository>().deleteTrack(track);
      _loadTracks();
      if (mounted) _showSnack('Трек "${track.title}" видалено');
    } catch (e) {
      if (mounted) _showSnack('Не вдалося видалити трек: $e');
    }
  }

  Future<void> _toggleFavorite(Track track) async {
    try {
      await context.read<IMusicRepository>().toggleFavorite(track.id!, !track.isFavorite);
      _loadTracks();
    } catch (e) {
      if (mounted) _showSnack('Не вдалося оновити статус: $e');
    }
  }

  void _showSnack(String msg) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Моя Бібліотека'),
        actions: [
          PopupMenuButton<TrackSortType>(
            icon: const Icon(Icons.sort),
            onSelected: (val) {
              _sortType = val;
              _loadTracks();
            },
            itemBuilder: (_) => [
              const PopupMenuItem(value: TrackSortType.byDateAdded, child: Text('За датою')),
              const PopupMenuItem(value: TrackSortType.byTitle, child: Text('За назвою (A-Z)')),
              const PopupMenuItem(value: TrackSortType.bySize, child: Text('За розміром')),
            ],
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        tooltip: "Додати треки",
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          final result = await Navigator.pushNamed(context, '/explorer');
          if (result == true && mounted) _loadTracks();
        },
      ),
      body: FutureBuilder<List<Track>>(
        future: _tracksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Помилка: ${snapshot.error}'));
          }
          final tracks = snapshot.data ?? [];
          if (tracks.isEmpty) return _buildEmptyState();

          return ListView.builder(
            itemCount: tracks.length,
            itemBuilder: (context, index) => _buildTrackItem(tracks[index]),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Ваша бібліотека порожня.', style: TextStyle(fontSize: 18, color: Colors.grey)),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: () async {
              final result = await Navigator.pushNamed(context, '/explorer');
              if (result == true && mounted) _loadTracks();
            },
            icon: const Icon(Icons.add),
            label: const Text("Додати треки"),
          )
        ],
      ),
    );
  }

  Widget _buildTrackItem(Track track) {
    return Dismissible(
      key: Key(track.id.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => _deleteTrack(track),
      child: MusicTrackTile(
        track: track,
        onPlay: () => Navigator.pushNamed(context, '/player', arguments: track),
        onToggleFavorite: () => _toggleFavorite(track),
      ),
    );
  }
}