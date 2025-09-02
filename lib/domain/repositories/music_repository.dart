import '../entities/category_entity.dart';
import '../entities/album_entity.dart';
import '../entities/artist_entity.dart';
import '../entities/playlist_entity.dart';

/// Repository interface for music catalog operations
abstract class MusicRepository {
  /// Get all music categories/genres
  Future<List<CategoryEntity>> getCategories();

  /// Get playlists for a specific category
  Future<List<PlaylistEntity>> getCategoryPlaylists(int categoryId);

  /// Get artists for a specific category
  Future<List<ArtistEntity>> getCategoryArtists(int categoryId);

  /// Get albums for a specific category
  Future<List<AlbumEntity>> getCategoryAlbums(int categoryId);

  /// Get playlist details by ID
  Future<PlaylistEntity> getPlaylistById(int id);

  /// Get album details by ID
  Future<AlbumEntity> getAlbumById(int id);

  /// Get artist details by ID
  Future<ArtistEntity> getArtistById(int id);

  /// Search for artists
  Future<List<ArtistEntity>> searchArtists(String query);

  /// Search for albums
  Future<List<AlbumEntity>> searchAlbums(String query);

  /// Search for playlists
  Future<List<PlaylistEntity>> searchPlaylists(String query);
}
