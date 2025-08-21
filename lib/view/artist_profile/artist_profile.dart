import 'package:flutter/material.dart';
import 'package:music_media/data/model/artist.dart';
import 'package:music_media/view/artist_profile/artist_profile_widgets.dart';

import '../list_tracks/list_tracks.dart';

class ArtistProfile extends StatelessWidget {
  final Artist artist;
  const ArtistProfile({super.key, required this.artist});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: CustomScrollView(
        slivers: [
          ArtistProfileWidgets.sliverAppBar(context, artist),
          ArtistProfileWidgets.title(),
          SliverToBoxAdapter(
              child: ListTracks(item: artist, type: 'artist', scrolling: true))
        ],
      ),
    );
  }
}
