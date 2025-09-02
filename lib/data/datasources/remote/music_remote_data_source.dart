import '../../model/track.dart';
import '../../model/playlist.dart';
import '../../model/album.dart';
import '../../model/artist.dart';
import '../../model/category.dart';

/// Abstract class defining the contract for remote music data operations
abstract class MusicRemoteDataSource {
  Future<List<Category>> getCategories();
  Future<List<Playlist>> getCategoryPlaylists(int categoryId);
  Future<List<Artist>> getCategoryArtists(int categoryId);
  Future<List<Album>> getCategoryAlbums(int categoryId);
  Future<List<Track>> searchTracks(String query);
  Future<List<Track>> getPlaylistTracks(int playlistId);
  Future<List<Track>> getAlbumTracks(int albumId);
  Future<List<Track>> getArtistTopTracks(int artistId);
  Future<List<Artist>> searchArtists(String query);
  Future<List<Album>> searchAlbums(String query);
  Future<List<Playlist>> searchPlaylists(String query);
}
