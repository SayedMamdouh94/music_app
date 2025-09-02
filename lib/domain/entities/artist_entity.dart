import 'album_entity.dart';
import 'track_entity.dart';

/// Domain entity representing a music artist
class ArtistEntity {
  final int id;
  final String name;
  final String imageUrl;
  final List<AlbumEntity> albums;
  final List<TrackEntity> topTracks;
  final int? fanCount;

  const ArtistEntity({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.albums = const [],
    this.topTracks = const [],
    this.fanCount,
  });

  ArtistEntity copyWith({
    int? id,
    String? name,
    String? imageUrl,
    List<AlbumEntity>? albums,
    List<TrackEntity>? topTracks,
    int? fanCount,
  }) {
    return ArtistEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      albums: albums ?? this.albums,
      topTracks: topTracks ?? this.topTracks,
      fanCount: fanCount ?? this.fanCount,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ArtistEntity && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
