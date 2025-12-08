import 'dart:convert';

class RemoteTrack {
  final String id;
  final String title;
  final String artist;
  final double sizeMb;

  RemoteTrack({
    required this.id,
    required this.title,
    required this.artist,
    required this.sizeMb,
  });

  factory RemoteTrack.fromJson(Map<String, dynamic> json) {
    return RemoteTrack(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? 'Unknown Title',
      artist: json['artist'] as String? ?? 'Unknown Artist',
      sizeMb: (json['sizeMb'] as num?)?.toDouble() ?? 0.0,
    );
  }

  static List<RemoteTrack> parseList(String jsonString) {
    try {
      final decoded = jsonDecode(jsonString) as List<dynamic>;
      return decoded.map((item) => RemoteTrack.fromJson(item as Map<String, dynamic>)).toList();
    } catch (e) {
      print("Error parsing remote tracks: $e");
      return [];
    }
  }
}