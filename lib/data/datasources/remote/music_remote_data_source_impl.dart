import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../model/track.dart';
import '../../model/playlist.dart';
import '../../model/album.dart';
import '../../model/artist.dart';
import '../../model/category.dart';
import 'music_remote_data_source.dart';

/// Implementation of MusicRemoteDataSource using Deezer API
class MusicRemoteDataSourceImpl implements MusicRemoteDataSource {
  final String baseUrl = "https://api.deezer.com";

  // Cache for categories data
  static List<Category>? _cachedCategories;
  static DateTime? _lastCacheTime;
  static const cacheDuration = Duration(minutes: 10);

  // HTTP client with timeout configuration
  static final http.Client _httpClient = http.Client();
  static const Duration _requestTimeout = Duration(seconds: 8);

  @override
  Future<List<Category>> getCategories() async {
    // Check if we have cached data that's still valid
    if (_cachedCategories != null &&
        _lastCacheTime != null &&
        DateTime.now().difference(_lastCacheTime!) < cacheDuration) {
      return _cachedCategories!;
    }

    List<Category> categories = [];
    try {
      final response = await _httpClient
          .get(Uri.parse('$baseUrl/genre'))
          .timeout(_requestTimeout);
      if (response.statusCode == 200) {
        final categoryItems = (jsonDecode(response.body)['data'] ?? []) as List;

        // Process only first 10 categories for better performance
        final filteredCategories = categoryItems
            .take(10)
            .where((category) => category != null && category['id'] != 0)
            .toList();

        categories = await _fetchCategoriesInBatches(filteredCategories);

        // Cache the results
        _cachedCategories = categories;
        _lastCacheTime = DateTime.now();
      }
    } catch (e) {
      // Return cached data if available, otherwise empty list
      if (_cachedCategories != null) {
        return _cachedCategories!;
      }
      throw Exception('Failed to load categories: ${e.toString()}');
    }

    return categories;
  }

  Future<List<Category>> _fetchCategoriesInBatches(List categoryItems) async {
    const batchSize = 3; // Process 3 categories at a time
    List<Category> allCategories = [];

    for (int i = 0; i < categoryItems.length; i += batchSize) {
      final batch = categoryItems.skip(i).take(batchSize);

      // Process batch in parallel
      final batchResults = await Future.wait(
        batch.map((category) async {
          try {
            final playlists = await getCategoryPlaylists(category['id']);
            final artists = await getCategoryArtists(category['id']);
            final albums = await getCategoryAlbums(category['id']);

            return Category.fromJson(category, playlists, artists, albums);
          } catch (e) {
            // Return category without data if API call fails
            return Category.fromJson(
                category, <Playlist>[], <Artist>[], <Album>[]);
          }
        }),
      );
      allCategories.addAll(batchResults);
    }

    return allCategories;
  }

  @override
  Future<List<Playlist>> getCategoryPlaylists(int categoryId) async {
    List<Playlist> playlists = [];
    final response = await _httpClient
        .get(Uri.parse('$baseUrl/chart/$categoryId/playlists?limit=10'))
        .timeout(_requestTimeout);
    if (response.statusCode == 200) {
      final items = (jsonDecode(response.body)['data'] ?? []) as List;
      playlists = items.map((e) => Playlist.fromJson(e)).toList();
    }
    return playlists;
  }

  @override
  Future<List<Artist>> getCategoryArtists(int categoryId) async {
    List<Artist> artists = [];
    final response = await _httpClient
        .get(Uri.parse('$baseUrl/chart/$categoryId/artists?limit=10'))
        .timeout(_requestTimeout);
    if (response.statusCode == 200) {
      final items = (jsonDecode(response.body)['data'] ?? []) as List;
      artists = items.map((e) => Artist.fromJson(e)).toList();
    }
    return artists;
  }

  @override
  Future<List<Album>> getCategoryAlbums(int categoryId) async {
    List<Album> albums = [];
    final response = await _httpClient
        .get(Uri.parse('$baseUrl/chart/$categoryId/albums?limit=10'))
        .timeout(_requestTimeout);
    if (response.statusCode == 200) {
      final items = (jsonDecode(response.body)['data'] ?? []) as List;
      albums = items.map((e) => Album.fromJson(e)).toList();
    }
    return albums;
  }

  @override
  Future<List<Track>> searchTracks(String query) async {
    List<Track> tracks = [];
    final response = await _httpClient
        .get(Uri.parse('$baseUrl/search/track?q=$query&limit=20'))
        .timeout(_requestTimeout);
    if (response.statusCode == 200) {
      final items = (jsonDecode(response.body)['data'] ?? []) as List;
      tracks = items.map((e) => Track.fromJson(e, null)).toList();
    }
    return tracks;
  }

  @override
  Future<List<Track>> getPlaylistTracks(int playlistId) async {
    List<Track> tracks = [];
    final response = await _httpClient
        .get(Uri.parse('$baseUrl/playlist/$playlistId/tracks'))
        .timeout(_requestTimeout);
    if (response.statusCode == 200) {
      final items = (jsonDecode(response.body)['data'] ?? []) as List;
      tracks = items.map((e) => Track.fromJson(e, null)).toList();
    }
    return tracks;
  }

  @override
  Future<List<Track>> getAlbumTracks(int albumId) async {
    List<Track> tracks = [];
    final response = await _httpClient
        .get(Uri.parse('$baseUrl/album/$albumId/tracks'))
        .timeout(_requestTimeout);
    if (response.statusCode == 200) {
      final items = (jsonDecode(response.body)['data'] ?? []) as List;
      tracks = items.map((e) => Track.fromJson(e, null)).toList();
    }
    return tracks;
  }

  @override
  Future<List<Track>> getArtistTopTracks(int artistId) async {
    List<Track> tracks = [];
    final response = await _httpClient
        .get(Uri.parse('$baseUrl/artist/$artistId/top'))
        .timeout(_requestTimeout);
    if (response.statusCode == 200) {
      final items = (jsonDecode(response.body)['data'] ?? []) as List;
      tracks = items.map((e) => Track.fromJson(e, null)).toList();
    }
    return tracks;
  }

  @override
  Future<List<Artist>> searchArtists(String query) async {
    List<Artist> artists = [];
    final response = await _httpClient
        .get(Uri.parse('$baseUrl/search/artist?q=$query&limit=20'))
        .timeout(_requestTimeout);
    if (response.statusCode == 200) {
      final items = (jsonDecode(response.body)['data'] ?? []) as List;
      artists = items.map((e) => Artist.fromJson(e)).toList();
    }
    return artists;
  }

  @override
  Future<List<Album>> searchAlbums(String query) async {
    List<Album> albums = [];
    final response = await _httpClient
        .get(Uri.parse('$baseUrl/search/album?q=$query&limit=20'))
        .timeout(_requestTimeout);
    if (response.statusCode == 200) {
      final items = (jsonDecode(response.body)['data'] ?? []) as List;
      albums = items.map((e) => Album.fromJson(e)).toList();
    }
    return albums;
  }

  @override
  Future<List<Playlist>> searchPlaylists(String query) async {
    List<Playlist> playlists = [];
    final response = await _httpClient
        .get(Uri.parse('$baseUrl/search/playlist?q=$query&limit=20'))
        .timeout(_requestTimeout);
    if (response.statusCode == 200) {
      final items = (jsonDecode(response.body)['data'] ?? []) as List;
      playlists = items.map((e) => Playlist.fromJson(e)).toList();
    }
    return playlists;
  }
}
