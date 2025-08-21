import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_media/data/model/album.dart';
import 'package:music_media/data/model/artist.dart';
import 'package:music_media/data/model/playlist.dart';
import 'package:music_media/data/model/track.dart';

import '../../view/artist_profile/artist_profile.dart';
import '../../view/play_audio/play_audio.dart';
import '../../view/tracks_page/tracks_page.dart';
import '../../view_model/play_audio/play_audio_bloc.dart';
import '../../view_model/tracks/tracks_bloc.dart';
import 'const_colors.dart';

class Widgets {
  static trackWidget(Track track, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [ConstColors.creamOp2, ConstColors.redOp8],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(width: 1, color: ConstColors.redOp8),
      ),
      padding: const EdgeInsets.all(10),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: track.isDownloaded
              ? Image.file(
                  File(track.imageUrl),
                  fit: BoxFit.fill,
                  width: 50,
                  height: 50,
                )
              : Image.network(track.imageUrl,
                  width: 50, height: 50, fit: BoxFit.cover),
        ),
        title: Text(track.name),
        trailing: IconButton(
          icon: const Icon(Icons.play_arrow),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (_) => PlayAudioBloc(),
                  child: PlayAudio(
                    track: track,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  static artistWidget(Artist artist, BuildContext context) {
    return InkWell(
      onTap: () => {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (_) => TracksBloc(),
              child: ArtistProfile(artist: artist),
            ),
          ),
        ),
      },
      child: Container(
        width: 80,
        height: 80,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(width: 2, color: ConstColors.creamOp2),
          image: DecorationImage(
            image: NetworkImage(
              artist.imageUrl,
            ),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  static playlistWidget(Playlist playlist, BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => BlocProvider(
                    create: (_) => TracksBloc(),
                    child: TracksPage(item: playlist, type: 'playlist'),
                  )),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 7),
        decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(playlist.imageUrl), fit: BoxFit.fill),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  static albumWidget(Album album, BuildContext context) {
    return InkWell(
      onTap: () => {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (_) => TracksBloc(),
              child: TracksPage(
                item: album,
                type: 'album',
              ),
            ),
          ),
        ),
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: ConstColors.cream.withOpacity(0.15),
              blurRadius: 6,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              CachedNetworkImage(
                imageUrl: album.imageUrl,
                fit: BoxFit.fill,
                placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(strokeWidth: 2)),
                errorWidget: (context, url, error) =>
                    const Icon(Icons.error, size: 40),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: ConstColors.redOp8,
                  ),
                  child: Text(
                    album.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
