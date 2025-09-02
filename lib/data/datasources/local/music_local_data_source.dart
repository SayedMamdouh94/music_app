import '../../hive/track_hive.dart';

/// Abstract class defining the contract for local music data operations
abstract class MusicLocalDataSource {
  Future<List<TrackHive>> getFavoriteTracks();
  Future<void> addToFavorites(TrackHive track);
  Future<void> removeFromFavorites(int trackId);
  Future<bool> isFavorite(int trackId);
  Future<void> clearFavorites();
}
