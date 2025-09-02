import '../entities/track_entity.dart';
import '../repositories/track_repository.dart';

/// Use case for searching tracks
class SearchTracksUseCase {
  final TrackRepository _repository;

  SearchTracksUseCase(this._repository);

  Future<List<TrackEntity>> call(String query) async {
    if (query.trim().isEmpty) {
      return [];
    }

    try {
      return await _repository.searchTracks(query);
    } catch (e) {
      throw Exception('Failed to search tracks: ${e.toString()}');
    }
  }
}
