import '../entities/track_entity.dart';

/// Repository interface for track-related operations
/// This defines the contract that will be implemented in the data layer
abstract class TrackRepository {
  /// Search for tracks with a query string
  Future<List<TrackEntity>> searchTracks(String query);

  /// Get tracks for a specific playlist
  Future<List<TrackEntity>> getPlaylistTracks(int playlistId);

  /// Get tracks for a specific album
  Future<List<TrackEntity>> getAlbumTracks(int albumId);

  /// Get top tracks for an artist
  Future<List<TrackEntity>> getArtistTopTracks(int artistId);

  /// Get favorite tracks from local storage
  Future<List<TrackEntity>> getFavoriteTracks();

  /// Add track to favorites
  Future<void> addToFavorites(TrackEntity track);

  /// Remove track from favorites
  Future<void> removeFromFavorites(int trackId);

  /// Check if track is in favorites
  Future<bool> isFavorite(int trackId);
}
