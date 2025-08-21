import 'package:flutter/material.dart';
import 'package:music_media/view/list_tracks/list_tracks.dart';

class TracksPage extends StatelessWidget {
  final dynamic item;
  final String type; // playlist or album
  const TracksPage({super.key, required this.item, required this.type});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(item.name)),
      body: ListTracks(item: item, type: type),
    );
  }
}
