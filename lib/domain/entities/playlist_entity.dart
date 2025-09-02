import 'track_entity.dart';

/// Domain entity representing a music playlist
class PlaylistEntity {
  final int id;
  final String name;
  final String imageUrl;
  final String description;
  final List<TrackEntity> tracks;
  final int? trackCount;
  final String? creatorName;

  const PlaylistEntity({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.description = '',
    this.tracks = const [],
    this.trackCount,
    this.creatorName,
  });

  PlaylistEntity copyWith({
    int? id,
    String? name,
    String? imageUrl,
    String? description,
    List<TrackEntity>? tracks,
    int? trackCount,
    String? creatorName,
  }) {
    return PlaylistEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      tracks: tracks ?? this.tracks,
      trackCount: trackCount ?? this.trackCount,
      creatorName: creatorName ?? this.creatorName,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PlaylistEntity && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
