import 'package:flutter/material.dart';

import '../../core/constants/widgets.dart';
import '../../data/hive/tracks_box.dart';
import '../../data/model/track.dart';

class ListTracksWidgets {
  static void syncTracksWithHive(List<Track> tracks) {
    List hiveKeys = tracksBox.keys.toList();
    List currentTracks = tracks;
    for (Track currentTrack in currentTracks) {
      final savedHive = hiveKeys.firstWhere(
        (hiveKey) => hiveKey == currentTrack.id,
        orElse: () => null,
      );
      if (savedHive == null) {
        currentTrack.isDownloaded = false;
        currentTrack.linkUrl = currentTrack.savedNetworkUrl;
        currentTrack.imageUrl = currentTrack.savedNetworkImage;
      } else {
        currentTrack.isDownloaded = true;
        currentTrack.linkUrl = tracksBox.get(savedHive).linkUrl;
        currentTrack.imageUrl = tracksBox.get(savedHive).imageUrl;
      }
    }
  }

  static loading() {
    return const Center(child: CircularProgressIndicator());
  }

  static loaded(List<Track> tracks, bool scrolling) {
    if (tracks.isNotEmpty) {
      return ListView.builder(
          shrinkWrap: scrolling,
          physics: scrolling ? const NeverScrollableScrollPhysics() : null,
          itemCount: tracks.length,
          itemBuilder: (context, index) {
            final track = tracks[index];
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 5,
              ),
              child: Widgets.trackWidget(track, context),
            );
          });
    }
    return const Center(
      child: Text('Nothing found !'),
    );
  }

  static error() {
    return const Center(child: Text('please try again'));
  }
}
