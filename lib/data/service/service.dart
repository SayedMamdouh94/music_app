import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:music_media/data/model/album.dart';
import 'package:music_media/data/model/artist.dart';
import 'package:music_media/data/model/track.dart';

import '../model/category.dart' as Catego;
import '../model/playlist.dart';

class Service {
  final String baseUrl = "https://api.deezer.com";

  Future<List<Catego.Category>> getCategories() async {
    List<Catego.Category> categories = [];
    final response = await http.get(Uri.parse('$baseUrl/genre'));
    if (response.statusCode == 200) {
      final categoryItems = (jsonDecode(response.body)['data'] ?? []) as List;
      categories = await Future.wait(
        categoryItems
            .take(15)
            .where((category) => category != null && category['id'] != 0)
            .map(
          (category) async {
            final playlists = await getPlayLists(category['id']);
            final artists = await getArtists(category['id']);
            final albums = await getAlbums(category['name']);
            return Catego.Category.fromJson(
                category, playlists, artists, albums);
          },
        ),
      );
    }
    return categories;
  }

  Future<List<Playlist>> getPlayLists(int genreId) async {
    List<Playlist> playlists = [];
    final response =
        await http.get(Uri.parse('$baseUrl/chart/$genreId/playlists?limit=10'));
    if (response.statusCode == 200) {
      final items = (jsonDecode(response.body)['data'] ?? []) as List;
      playlists = items.map((e) => Playlist.fromJson(e)).toList();
    }
    return playlists;
  }

  Future<List<Artist>> getArtists(int genreId) async {
    List<Artist> artists = [];
    final response = await http
        .get(Uri.parse('$baseUrl/chart/$genreId/artists?limit=20&index=20'));
    if (response.statusCode == 200) {
      final items = (jsonDecode(response.body)['data'] ?? []) as List;
      artists = items.map((e) => Artist.fromJson(e)).toList();
    }
    return artists;
  }

  Future<List<Album>> getAlbums(String genreName) async {
    List<Album> albums = [];
    final response =
        await http.get(Uri.parse('$baseUrl/search/album?q=$genreName'));
    if (response.statusCode == 200) {
      final items = (jsonDecode(response.body)['data'] ?? []) as List;
      albums = items.take(15).map((e) => Album.fromJson(e)).toList();
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

    final response = await http.get(url);
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
    final response =
        await http.get(Uri.parse('$baseUrl/search/$type?q=$query'));
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
}
