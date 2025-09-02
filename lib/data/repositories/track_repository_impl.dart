import '../../domain/entities/track_entity.dart';
import '../../domain/repositories/track_repository.dart';
import '../datasources/local/music_local_data_source.dart';
import '../datasources/remote/music_remote_data_source.dart';
import '../hive/track_hive.dart';
import '../model/track.dart';

/// Implementation of TrackRepository
class TrackRepositoryImpl implements TrackRepository {
  final MusicRemoteDataSource _remoteDataSource;
  final MusicLocalDataSource _localDataSource;

  TrackRepositoryImpl({
    required MusicRemoteDataSource remoteDataSource,
    required MusicLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  @override
  Future<List<TrackEntity>> searchTracks(String query) async {
    try {
      final tracks = await _remoteDataSource.searchTracks(query);
      return tracks.map((track) => _trackToEntity(track)).toList();
    } catch (e) {
      throw Exception('Failed to search tracks: ${e.toString()}');
    }
  }

  @override
  Future<List<TrackEntity>> getAlbumTracks(int albumId) async {
    try {
      final tracks = await _remoteDataSource.getAlbumTracks(albumId);
      return tracks.map((track) => _trackToEntity(track)).toList();
    } catch (e) {
      throw Exception('Failed to get album tracks: ${e.toString()}');
    }
  }

  @override
  Future<List<TrackEntity>> getArtistTopTracks(int artistId) async {
    try {
      final tracks = await _remoteDataSource.getArtistTopTracks(artistId);
      return tracks.map((track) => _trackToEntity(track)).toList();
    } catch (e) {
      throw Exception('Failed to get artist top tracks: ${e.toString()}');
    }
  }

  @override
  Future<List<TrackEntity>> getPlaylistTracks(int playlistId) async {
    try {
      final tracks = await _remoteDataSource.getPlaylistTracks(playlistId);
      return tracks.map((track) => _trackToEntity(track)).toList();
    } catch (e) {
      throw Exception('Failed to get playlist tracks: ${e.toString()}');
    }
  }

  @override
  Future<List<TrackEntity>> getFavoriteTracks() async {
    try {
      final hiveTracksList = await _localDataSource.getFavoriteTracks();
      return hiveTracksList
          .map((hiveTrack) => _hiveToEntity(hiveTrack))
          .toList();
    } catch (e) {
      throw Exception('Failed to get favorite tracks: ${e.toString()}');
    }
  }

  @override
  Future<void> addToFavorites(TrackEntity track) async {
    try {
      final hiveTrack = _entityToHive(track);
      await _localDataSource.addToFavorites(hiveTrack);
    } catch (e) {
      throw Exception('Failed to add to favorites: ${e.toString()}');
    }
  }

  @override
  Future<void> removeFromFavorites(int trackId) async {
    try {
      await _localDataSource.removeFromFavorites(trackId);
    } catch (e) {
      throw Exception('Failed to remove from favorites: ${e.toString()}');
    }
  }

  @override
  Future<bool> isFavorite(int trackId) async {
    try {
      return await _localDataSource.isFavorite(trackId);
    } catch (e) {
      return false;
    }
  }

  /// Convert Track model to TrackEntity
  TrackEntity _trackToEntity(Track track) {
    return TrackEntity(
      id: track.id,
      name: track.name,
      artist: track.artist,
      imageUrl: track.imageUrl,
      previewUrl: track.linkUrl,
      streamUrl: track.linkUrl,
      isDownloaded: track.isDownloaded,
      isFavorite: false, // This will be determined by checking local storage
      duration: const Duration(seconds: 30), // Default preview duration
    );
  }

  /// Convert TrackEntity to TrackHive
  TrackHive _entityToHive(TrackEntity entity) {
    return TrackHive(
      name: entity.name,
      artist: entity.artist,
      imageUrl: entity.imageUrl,
      linkUrl: entity.previewUrl,
    );
  }

  /// Convert TrackHive to TrackEntity
  TrackEntity _hiveToEntity(TrackHive hive) {
    return TrackEntity(
      id: 0, // Default ID since Hive uses auto-generated keys
      name: hive.name,
      artist: hive.artist,
      imageUrl: hive.imageUrl,
      previewUrl: hive.linkUrl,
      streamUrl: hive.linkUrl,
      isDownloaded: true, // If it's in Hive, it's downloaded
      isFavorite: true, // If it's in favorites, it's favorite
      duration: const Duration(seconds: 30), // Default preview duration
    );
  }
}
