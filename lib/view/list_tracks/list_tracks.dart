import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_media/view_model/tracks/tracks_bloc.dart';

import 'list_tracks_widgets.dart';

class ListTracks extends StatefulWidget {
  final dynamic item; //   playlist, artist or alum
  final String type;
  final bool scrolling;
  const ListTracks({
    super.key,
    required this.item,
    required this.type,
    this.scrolling = false,
  });

  @override
  State<ListTracks> createState() => _ListTracksState();
}

class _ListTracksState extends State<ListTracks> {
  @override
  void initState() {
    if (widget.item.tracks.isEmpty) {
      context
          .read<TracksBloc>()
          .add(GetTracksEvent(type: widget.type, item: widget.item));
    } else {
      context.read<TracksBloc>().add(LoadedEvent());
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TracksBloc, TracksState>(
      builder: (context, state) {
        if (state is TracksLoading) {
          return ListTracksWidgets.loading();
        } else {
          if (state is TracksLoaded) {
            ListTracksWidgets.syncTracksWithHive(widget.item.tracks);
            return ListTracksWidgets.loaded(
                widget.item.tracks, widget.scrolling);
          } else {
            if (state is TracksError) {
              return ListTracksWidgets.error();
            }
          }
          return const SizedBox.shrink();
        }
      },
    );
  }
}
