import '../entities/track_entity.dart';
import '../repositories/track_repository.dart';

/// Use case for managing favorite tracks
class FavoritesUseCase {
  final TrackRepository _repository;

  FavoritesUseCase(this._repository);

  Future<List<TrackEntity>> getFavorites() async {
    try {
      return await _repository.getFavoriteTracks();
    } catch (e) {
      throw Exception('Failed to load favorites: ${e.toString()}');
    }
  }

  Future<void> addToFavorites(TrackEntity track) async {
    try {
      await _repository.addToFavorites(track);
    } catch (e) {
      throw Exception('Failed to add to favorites: ${e.toString()}');
    }
  }

  Future<void> removeFromFavorites(int trackId) async {
    try {
      await _repository.removeFromFavorites(trackId);
    } catch (e) {
      throw Exception('Failed to remove from favorites: ${e.toString()}');
    }
  }

  Future<bool> isFavorite(int trackId) async {
    try {
      return await _repository.isFavorite(trackId);
    } catch (e) {
      return false;
    }
  }
}
