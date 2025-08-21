import 'package:music_media/data/model/track.dart';

import '../../core/constants/const_madia.dart';

class Playlist {
  final int id;
  final String name;
  final String imageUrl;
  List<Track> tracks;

  Playlist({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.tracks = const [],
  });

  factory Playlist.fromJson(Map<String, dynamic> json) {
    return Playlist(
      id: json['id'],
      name: json['title'] ?? '',
      imageUrl: json['picture'] ?? ConstMedia.imageDefault,
    );
  }
}
