import '../../domain/entities/category_entity.dart';
import '../../domain/entities/playlist_entity.dart';
import '../../domain/entities/album_entity.dart';
import '../../domain/entities/artist_entity.dart';
import '../../domain/repositories/music_repository.dart';
import '../datasources/remote/music_remote_data_source.dart';
import '../model/category.dart';
import '../model/playlist.dart';
import '../model/album.dart';
import '../model/artist.dart';

/// Implementation of MusicRepository
class MusicRepositoryImpl implements MusicRepository {
  final MusicRemoteDataSource _remoteDataSource;

  MusicRepositoryImpl({
    required MusicRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<List<CategoryEntity>> getCategories() async {
    try {
      final categories = await _remoteDataSource.getCategories();
      return categories.map((category) => _categoryToEntity(category)).toList();
    } catch (e) {
      throw Exception('Failed to get categories: ${e.toString()}');
    }
  }

  @override
  Future<List<PlaylistEntity>> getCategoryPlaylists(int categoryId) async {
    try {
      final playlists =
          await _remoteDataSource.getCategoryPlaylists(categoryId);
      return playlists.map((playlist) => _playlistToEntity(playlist)).toList();
    } catch (e) {
      throw Exception('Failed to get category playlists: ${e.toString()}');
    }
  }

  @override
  Future<List<ArtistEntity>> getCategoryArtists(int categoryId) async {
    try {
      final artists = await _remoteDataSource.getCategoryArtists(categoryId);
      return artists.map((artist) => _artistToEntity(artist)).toList();
    } catch (e) {
      throw Exception('Failed to get category artists: ${e.toString()}');
    }
  }

  @override
  Future<List<AlbumEntity>> getCategoryAlbums(int categoryId) async {
    try {
      final albums = await _remoteDataSource.getCategoryAlbums(categoryId);
      return albums.map((album) => _albumToEntity(album)).toList();
    } catch (e) {
      throw Exception('Failed to get category albums: ${e.toString()}');
    }
  }

  @override
  Future<PlaylistEntity> getPlaylistById(int id) async {
    try {
      // For now, return a basic playlist since we need to implement this method
      // In a real implementation, you'd have a specific API endpoint for this
      final playlists = await _remoteDataSource.getCategoryPlaylists(0);
      final playlist = playlists.firstWhere((p) => p.id == id,
          orElse: () => throw Exception('Playlist not found'));
      return _playlistToEntity(playlist);
    } catch (e) {
      throw Exception('Failed to get playlist by ID: ${e.toString()}');
    }
  }

  @override
  Future<AlbumEntity> getAlbumById(int id) async {
    try {
      // For now, return a basic album since we need to implement this method
      // In a real implementation, you'd have a specific API endpoint for this
      final albums = await _remoteDataSource.getCategoryAlbums(0);
      final album = albums.firstWhere((a) => a.id == id,
          orElse: () => throw Exception('Album not found'));
      return _albumToEntity(album);
    } catch (e) {
      throw Exception('Failed to get album by ID: ${e.toString()}');
    }
  }

  @override
  Future<ArtistEntity> getArtistById(int id) async {
    try {
      // For now, return a basic artist since we need to implement this method
      // In a real implementation, you'd have a specific API endpoint for this
      final artists = await _remoteDataSource.getCategoryArtists(0);
      final artist = artists.firstWhere((a) => a.id == id,
          orElse: () => throw Exception('Artist not found'));
      return _artistToEntity(artist);
    } catch (e) {
      throw Exception('Failed to get artist by ID: ${e.toString()}');
    }
  }

  @override
  Future<List<ArtistEntity>> searchArtists(String query) async {
    try {
      final artists = await _remoteDataSource.searchArtists(query);
      return artists.map((artist) => _artistToEntity(artist)).toList();
    } catch (e) {
      throw Exception('Failed to search artists: ${e.toString()}');
    }
  }

  @override
  Future<List<AlbumEntity>> searchAlbums(String query) async {
    try {
      final albums = await _remoteDataSource.searchAlbums(query);
      return albums.map((album) => _albumToEntity(album)).toList();
    } catch (e) {
      throw Exception('Failed to search albums: ${e.toString()}');
    }
  }

  @override
  Future<List<PlaylistEntity>> searchPlaylists(String query) async {
    try {
      final playlists = await _remoteDataSource.searchPlaylists(query);
      return playlists.map((playlist) => _playlistToEntity(playlist)).toList();
    } catch (e) {
      throw Exception('Failed to search playlists: ${e.toString()}');
    }
  }

  /// Convert Category model to CategoryEntity
  CategoryEntity _categoryToEntity(Category category) {
    return CategoryEntity(
      id: category.id,
      name: category.name,
      imageUrl: '', // Category model doesn't have image field
    );
  }

  /// Convert Playlist model to PlaylistEntity
  PlaylistEntity _playlistToEntity(Playlist playlist) {
    return PlaylistEntity(
      id: playlist.id,
      name: playlist.name,
      imageUrl: playlist.imageUrl,
      description: '', // Playlist model doesn't have description
      tracks: const [],
      trackCount: 0,
      creatorName: null,
    );
  }

  /// Convert Album model to AlbumEntity
  AlbumEntity _albumToEntity(Album album) {
    return AlbumEntity(
      id: album.id,
      name: album.name,
      imageUrl: album.imageUrl,
      artistName: '', // Album model doesn't have artist name
      tracks: const [],
      releaseDate: null,
      trackCount: 0,
    );
  }

  /// Convert Artist model to ArtistEntity
  ArtistEntity _artistToEntity(Artist artist) {
    return ArtistEntity(
      id: artist.id,
      name: artist.name,
      imageUrl: artist.imageUrl,
      albums: const [],
      topTracks: const [],
      fanCount: null,
    );
  }
}
