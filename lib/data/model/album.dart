import 'package:music_media/data/model/track.dart';

import '../../core/constants/const_madia.dart';

class Album {
  final int id;
  final String name;
  final String imageUrl;
  List<Track> tracks;

  Album({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.tracks = const [],
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      id: json['id'],
      name: json['title'],
      imageUrl: json['cover'] ?? ConstMedia.imageDefault,
    );
  }
}
