import 'package:flutter/material.dart';
import 'package:music_media/core/constants/widgets.dart';

import '../../data/model/track.dart';
import '../list_tracks/list_tracks_widgets.dart';

class SearchWidgets {
  static appBar(
    TextEditingController controller,
    String selectedType,
    VoidCallback onSearch,
    ValueChanged<String?> onChange,
  ) {
    final List<String> types = ["song", "artist", "album", "playlist"];
    return AppBar(
      title: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: "Search songs, artists, albums...",
          border: InputBorder.none,
          hintStyle: TextStyle(color: Colors.grey.shade400),
        ),
        textInputAction: TextInputAction.search,
        onSubmitted: (_) => onSearch,
      ),
      actions: [
        DropdownButton<String>(
          value: selectedType,
          items: types.map((t) {
            return DropdownMenuItem(value: t, child: Text(t));
          }).toList(),
          onChanged: onChange,
        ),
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: onSearch,
        )
      ],
    );
  }

  static listTracks(List tracks) {
    if (tracks.isNotEmpty) {
      ListTracksWidgets.syncTracksWithHive(tracks as List<Track>);
      return ListView.builder(
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
        },
      );
    }
    return const Center(
      child: Text('Search for something...'),
    );
  }

  static listArtist(List artists) {
    if (artists.isNotEmpty) {
      return ListView.builder(
        itemCount: artists.length,
        itemBuilder: (context, index) {
          final artist = artists[index];
          return SizedBox(
            height: 100,
            child: Row(
              children: [
                Widgets.artistWidget(artist, context),
                Expanded(
                  child: Text(
                    artist.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
    return const Center(
      child: Text('Search for something...'),
    );
  }

  static listAlbums(List albums) {
    if (albums.isNotEmpty) {
      return ListView.builder(
        itemCount: albums.length,
        itemBuilder: (context, index) {
          return SizedBox(
            height: 250,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Widgets.albumWidget(albums[index], context),
            ),
          );
        },
      );
    }
    return const Center(
      child: Text('Search for something...'),
    );
  }

  static listPlaylists(List playlists) {
    if (playlists.isNotEmpty) {
      return ListView.builder(
          itemCount: playlists.length,
          itemBuilder: (context, index) {
            final playlist = playlists[index];
            return SizedBox(
              height: 220,
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 150,
                    width: double.infinity,
                    child: Widgets.playlistWidget(playlist, context),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    playlist.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          });
    }
    return const Center(
      child: Text('Search for something...'),
    );
  }
}
