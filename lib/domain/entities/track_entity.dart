/// Domain entity representing a music track
/// This is pure business logic without any data layer dependencies
class TrackEntity {
  final int id;
  final String name;
  final String artist;
  final String imageUrl;
  final String previewUrl;
  final String streamUrl;
  final bool isDownloaded;
  final bool isFavorite;
  final Duration? duration;

  const TrackEntity({
    required this.id,
    required this.name,
    required this.artist,
    required this.imageUrl,
    required this.previewUrl,
    required this.streamUrl,
    this.isDownloaded = false,
    this.isFavorite = false,
    this.duration,
  });

  TrackEntity copyWith({
    int? id,
    String? name,
    String? artist,
    String? imageUrl,
    String? previewUrl,
    String? streamUrl,
    bool? isDownloaded,
    bool? isFavorite,
    Duration? duration,
  }) {
    return TrackEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      artist: artist ?? this.artist,
      imageUrl: imageUrl ?? this.imageUrl,
      previewUrl: previewUrl ?? this.previewUrl,
      streamUrl: streamUrl ?? this.streamUrl,
      isDownloaded: isDownloaded ?? this.isDownloaded,
      isFavorite: isFavorite ?? this.isFavorite,
      duration: duration ?? this.duration,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TrackEntity && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
