import 'package:music_media/data/model/track.dart';

import '../../core/constants/const_madia.dart';

class Artist {
  int id;
  String name;
  String imageUrl;
  List<Track> tracks;
  Artist({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.tracks = const [],
  });
  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      id: json['id'] ?? '',
      name: json['name'] ?? "Unknown Artist",
      imageUrl: json['picture'] ?? ConstMedia.imageDefault,
    );
  }
}
