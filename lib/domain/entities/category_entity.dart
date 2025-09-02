import 'album_entity.dart';
import 'artist_entity.dart';
import 'playlist_entity.dart';

/// Domain entity representing a music category/genre
class CategoryEntity {
  final int id;
  final String name;
  final String imageUrl;
  final List<PlaylistEntity> playlists;
  final List<ArtistEntity> artists;
  final List<AlbumEntity> albums;

  const CategoryEntity({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.playlists = const [],
    this.artists = const [],
    this.albums = const [],
  });

  CategoryEntity copyWith({
    int? id,
    String? name,
    String? imageUrl,
    List<PlaylistEntity>? playlists,
    List<ArtistEntity>? artists,
    List<AlbumEntity>? albums,
  }) {
    return CategoryEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      playlists: playlists ?? this.playlists,
      artists: artists ?? this.artists,
      albums: albums ?? this.albums,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CategoryEntity && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
