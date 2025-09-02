import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:music_media/data/model/album.dart';
import 'package:music_media/data/model/artist.dart';
import 'package:music_media/data/model/category.dart' as catego;
import 'package:music_media/data/model/track.dart';
import '../model/playlist.dart';

class Service {
  final String baseUrl = "https://api.deezer.com";

  // Cache for categories data
  static List<catego.Category>? _cachedCategories;
  static DateTime? _lastCacheTime;
  static const cacheDuration = Duration(minutes: 10); // Cache for 10 minutes

  // HTTP client with timeout configuration
  static final http.Client _httpClient = http.Client();
  static const Duration _requestTimeout = Duration(seconds: 8);

  Future<List<catego.Category>> getCategories() async {
    // Check if we have cached data that's still valid
    if (_cachedCategories != null &&
        _lastCacheTime != null &&
        DateTime.now().difference(_lastCacheTime!) < cacheDuration) {
      return _cachedCategories!;
    }

    List<catego.Category> categories = [];
    try {
      final response = await _httpClient
          .get(Uri.parse('$baseUrl/genre'))
          .timeout(_requestTimeout);
      if (response.statusCode == 200) {
        final categoryItems = (jsonDecode(response.body)['data'] ?? []) as List;

        // Process only first 10 categories instead of 15 for better performance
        final filteredCategories = categoryItems
            .take(10)
            .where((category) => category != null && category['id'] != 0)
            .toList();

        // Use parallel execution with limited concurrency to avoid overwhelming the API
        categories = await _fetchCategoriesInBatches(filteredCategories);

        // Cache the results
        _cachedCategories = categories;
        _lastCacheTime = DateTime.now();
      }
    } catch (e) {
      // If there's an error and we have cached data, return it
      if (_cachedCategories != null) {
        return _cachedCategories!;
      }
      rethrow;
    }
    return categories;
  }

  // Process categories in smaller batches to improve performance
  Future<List<catego.Category>> _fetchCategoriesInBatches(
      List categoryItems) async {
    const batchSize = 3; // Process 3 categories at a time
    List<catego.Category> allCategories = [];

    for (int i = 0; i < categoryItems.length; i += batchSize) {
      final batch = categoryItems.skip(i).take(batchSize);
      final batchResults = await Future.wait(
        batch.map((category) async {
          try {
            // Reduce the number of items fetched per category for faster loading
            final playlists = await getPlayLists(category['id'], limit: 6);
            final artists = await getArtists(category['id'], limit: 10);
            final albums = await getAlbums(category['name'], limit: 8);
            return catego.Category.fromJson(
                category, playlists, artists, albums);
          } catch (e) {
            // Return category with empty lists if individual fetch fails
            return catego.Category.fromJson(
                category, <Playlist>[], <Artist>[], <Album>[]);
          }
        }),
      );
      allCategories.addAll(batchResults);
    }

    return allCategories;
  }

  Future<List<Playlist>> getPlayLists(int genreId, {int limit = 10}) async {
    List<Playlist> playlists = [];
    final response = await _httpClient
        .get(Uri.parse('$baseUrl/chart/$genreId/playlists?limit=$limit'))
        .timeout(_requestTimeout);
    if (response.statusCode == 200) {
      final items = (jsonDecode(response.body)['data'] ?? []) as List;
      playlists = items.map((e) => Playlist.fromJson(e)).toList();
    }
    return playlists;
  }

  Future<List<Artist>> getArtists(int genreId,
      {int limit = 20, int index = 20}) async {
    List<Artist> artists = [];
    final response = await _httpClient
        .get(Uri.parse(
            '$baseUrl/chart/$genreId/artists?limit=$limit&index=$index'))
        .timeout(_requestTimeout);
    if (response.statusCode == 200) {
      final items = (jsonDecode(response.body)['data'] ?? []) as List;
      artists = items.map((e) => Artist.fromJson(e)).toList();
    }
    return artists;
  }

  Future<List<Album>> getAlbums(String genreName, {int limit = 15}) async {
    List<Album> albums = [];
    final response = await _httpClient
        .get(Uri.parse('$baseUrl/search/album?q=$genreName'))
        .timeout(_requestTimeout);
    if (response.statusCode == 200) {
      final items = (jsonDecode(response.body)['data'] ?? []) as List;
      albums = items.take(limit).map((e) => Album.fromJson(e)).toList();
    }
    return albums;
  }

  Future<List<Track>> getTracks(int id, {required String type}) async {
    List<Track> tracks = [];
    late Uri url;
    if (type == "playlist") {
      url = Uri.parse('$baseUrl/playlist/$id/tracks');
    } else if (type == "artist") {
      url = Uri.parse('$baseUrl/artist/$id/top?limit=20');
    } else if (type == "album") {
      url = Uri.parse('$baseUrl/album/$id/tracks');
    } else {
      throw Exception("Invalid type: $type");
    }

    final response = await _httpClient.get(url).timeout(_requestTimeout);
    if (response.statusCode == 200) {
      final items = (jsonDecode(response.body)['data'] ?? []) as List;
      tracks = items.map((e) => Track.fromJson(e, [])).toList();
    }
    return tracks;
  }

  Future<List> searching(String query, String type) async {
    if (type == 'song') {
      type = 'track';
    }
    final response = await _httpClient
        .get(Uri.parse('$baseUrl/search/$type?q=$query'))
        .timeout(_requestTimeout);
    if (response.statusCode == 200) {
      final items = (jsonDecode(response.body)['data'] ?? []) as List;
      switch (type) {
        case 'track':
          return items.map((e) => Track.fromJson(e, [])).toList();
        case 'artist':
          return items.map((e) => Artist.fromJson(e)).toList();
        case 'album':
          return items.map((e) => Album.fromJson(e)).toList();
        case 'playlist':
          return items.map((e) => Playlist.fromJson(e)).toList();
        default:
          return [];
      }
    } else {
      throw Exception("Search failed");
    }
  }

  // Method to clear cache manually if needed
  static void clearCache() {
    _cachedCategories = null;
    _lastCacheTime = null;
  }

  // Method to dispose HTTP client
  static void dispose() {
    _httpClient.close();
  }
}
