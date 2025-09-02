import '../entities/track_entity.dart';
import '../repositories/track_repository.dart';

/// Use case for getting tracks from playlists or albums
class GetTracksUseCase {
  final TrackRepository _repository;

  GetTracksUseCase(this._repository);

  Future<List<TrackEntity>> getPlaylistTracks(int playlistId) async {
    try {
      return await _repository.getPlaylistTracks(playlistId);
    } catch (e) {
      throw Exception('Failed to load playlist tracks: ${e.toString()}');
    }
  }

  Future<List<TrackEntity>> getAlbumTracks(int albumId) async {
    try {
      return await _repository.getAlbumTracks(albumId);
    } catch (e) {
      throw Exception('Failed to load album tracks: ${e.toString()}');
    }
  }

  Future<List<TrackEntity>> getArtistTopTracks(int artistId) async {
    try {
      return await _repository.getArtistTopTracks(artistId);
    } catch (e) {
      throw Exception('Failed to load artist tracks: ${e.toString()}');
    }
  }
}
