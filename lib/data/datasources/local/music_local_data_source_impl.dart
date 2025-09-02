import '../../hive/track_hive.dart';
import '../../hive/tracks_box.dart';
import 'music_local_data_source.dart';

/// Implementation of MusicLocalDataSource using Hive
class MusicLocalDataSourceImpl implements MusicLocalDataSource {
  @override
  Future<List<TrackHive>> getFavoriteTracks() async {
    try {
      final List<TrackHive> tracks = [];
      for (int i = 0; i < tracksBox.length; i++) {
        final track = tracksBox.getAt(i);
        if (track != null) {
          tracks.add(track);
        }
      }
      return tracks;
    } catch (e) {
      throw Exception('Failed to get favorite tracks: ${e.toString()}');
    }
  }

  @override
  Future<void> addToFavorites(TrackHive track) async {
    try {
      // Add track to the box using a generated key
      await tracksBox.add(track);
    } catch (e) {
      throw Exception('Failed to add to favorites: ${e.toString()}');
    }
  }

  @override
  Future<void> removeFromFavorites(int trackId) async {
    try {
      // Find and remove track with the given ID
      final keys = tracksBox.keys.toList();
      for (final key in keys) {
        if (key == trackId) {
          await tracksBox.delete(key);
          break;
        }
      }
    } catch (e) {
      throw Exception('Failed to remove from favorites: ${e.toString()}');
    }
  }

  @override
  Future<bool> isFavorite(int trackId) async {
    try {
      return tracksBox.containsKey(trackId);
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> clearFavorites() async {
    try {
      await tracksBox.clear();
    } catch (e) {
      throw Exception('Failed to clear favorites: ${e.toString()}');
    }
  }
}
