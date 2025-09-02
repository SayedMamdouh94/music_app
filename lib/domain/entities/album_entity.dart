import 'track_entity.dart';

/// Domain entity representing a music album
class AlbumEntity {
  final int id;
  final String name;
  final String imageUrl;
  final String artistName;
  final List<TrackEntity> tracks;
  final DateTime? releaseDate;
  final int? trackCount;

  const AlbumEntity({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.artistName,
    this.tracks = const [],
    this.releaseDate,
    this.trackCount,
  });

  AlbumEntity copyWith({
    int? id,
    String? name,
    String? imageUrl,
    String? artistName,
    List<TrackEntity>? tracks,
    DateTime? releaseDate,
    int? trackCount,
  }) {
    return AlbumEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      artistName: artistName ?? this.artistName,
      tracks: tracks ?? this.tracks,
      releaseDate: releaseDate ?? this.releaseDate,
      trackCount: trackCount ?? this.trackCount,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AlbumEntity && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
