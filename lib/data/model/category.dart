import 'package:music_media/data/model/album.dart';
import 'package:music_media/data/model/artist.dart';
import 'package:music_media/data/model/playlist.dart';

class Category {
  final int id;
  final String name;
  final List<Playlist> playlists;
  final List<Artist> artists;
  final List<Album> albums;

  Category({
    required this.id,
    required this.name,
    required this.playlists,
    required this.artists,
    required this.albums,
  });
  factory Category.fromJson(Map<String, dynamic> json, List<Playlist> playlists,
      List<Artist> artists, List<Album> albums) {
    return Category(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      playlists: playlists,
      artists: artists,
      albums: albums,
    );
  }
}
