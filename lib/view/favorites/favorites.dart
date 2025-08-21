import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_media/data/model/track.dart';
import 'package:music_media/view/favorites/favorites_widgets.dart';
import 'package:music_media/view/play_audio/play_audio.dart';

import '../../core/constants/const_colors.dart';
import '../../data/hive/tracks_box.dart';
import '../../view_model/play_audio/play_audio_bloc.dart';

class Favorites extends StatefulWidget {
  const Favorites({super.key});

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  void update() {
    setState(() {
      tracksBox;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FavoritesWidgets.appBar(),
      body: tracksBox.isNotEmpty
          ? ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              itemCount: tracksBox.length,
              itemBuilder: (build, index) {
                final track = tracksBox.getAt(index);
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => BlocProvider(
                          create: (_) => PlayAudioBloc(),
                          child: PlayAudio(
                            track: Track(
                              id: 0, //trackHive haven't id
                              name: track.name,
                              artist: track.artist,
                              imageUrl: track.imageUrl,
                              savedNetworkUrl: '',
                              savedNetworkImage: '',
                              linkUrl: track.linkUrl,
                              isDownloaded: true,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  child: Card(
                    color: ConstColors.creamOp2,
                    child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        leading: FavoritesWidgets.leading(track),
                        title: FavoritesWidgets.title(track),
                        subtitle: FavoritesWidgets.subtitle(track),
                        trailing: FavoritesWidgets.trailing(
                            track, update, index, context)),
                  ),
                );
              },
            )
          : const Center(child: Text('Nothing on your favorites')),
    );
  }
}
