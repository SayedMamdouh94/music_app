import 'dart:io';

import 'package:flutter/material.dart';
import 'package:music_media/data/hive/track_hive.dart';

import '../../core/constants/const_colors.dart';
import '../../data/hive/tracks_box.dart';

class FavoritesWidgets {
  static appBar() {
    return AppBar(
      title: Text(
        'My Favorites Songs',
        style: TextStyle(
          fontFamily: 'Italianno-Regular',
          fontSize: 55,
          fontWeight: FontWeight.bold,
          color: ConstColors.redOp8,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Text(
            '#${tracksBox.length.toString()}',
            style: const TextStyle(fontSize: 20, color: Colors.grey),
          ),
        )
      ],
    );
  }

  static leading(TrackHive track) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.file(File(track.imageUrl)),
    );
  }

  static title(TrackHive track) {
    return Text(
      track.name,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  static subtitle(TrackHive track) {
    return Text(
      track.artist,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w300,
      ),
    );
  }

  static trailing(TrackHive track, void Function() update, int index, context) {
    return IconButton(
      onPressed: () {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(
                  'Alert!',
                  style: TextStyle(color: ConstColors.redOp8),
                ),
                content: const Text(
                  'Would you really want to delete this song?',
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text(
                      'cancel',
                      style: TextStyle(color: ConstColors.redOp8),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child:
                        Text('OK', style: TextStyle(color: ConstColors.redOp8)),
                    onPressed: () async {
                      await File(track.linkUrl).delete();
                      await File(track.imageUrl).delete();
                      tracksBox.deleteAt(index);
                      update();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            });
      },
      icon: Icon(
        Icons.delete,
        color: ConstColors.redOp8,
      ),
    );
  }
}
