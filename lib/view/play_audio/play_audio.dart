import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:music_media/view/play_audio/play_audio_widgets.dart';
import 'package:path_provider/path_provider.dart';

import '../../data/hive/track_hive.dart';
import '../../data/hive/tracks_box.dart';
import '../../data/model/track.dart';
import '../../view_model/play_audio/play_audio_bloc.dart';

class PlayAudio extends StatefulWidget {
  final Track track;
  const PlayAudio({super.key, required this.track});

  @override
  State<PlayAudio> createState() => _PlayAudioState();
}

class _PlayAudioState extends State<PlayAudio> {
  late http.Client client;
  bool isLoading = false;
  double progress = 0.0;
  @override
  void initState() {
    client = http.Client();
    context.read<PlayAudioBloc>().add(
          LoadAudioEvent(
            isDownloaded: widget.track.isDownloaded,
            audioUrl: widget.track.linkUrl,
            imageUrl: widget.track.imageUrl,
          ),
        );
    super.initState();
  }

  @override
  void dispose() {
    client.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    Future<void> downloadMp3() async {
      setState(() {
        isLoading = true;
        progress = 0.0;
      });
      try {
        final directory = await getApplicationDocumentsDirectory();
        // ==== MP3 DOWNLOAD ====
        final filePath = '${directory.path}/${widget.track.id}.mp3';
        final tempPath = '$filePath.temp';
        final tempFile = File(tempPath);
        final request = await client
            .send(http.Request('GET', Uri.parse(widget.track.linkUrl)));
        if (request.statusCode == 200) {
          final sink = tempFile.openWrite();
          final contentLength = request.contentLength ?? 0;
          int received = 0;
          await for (final chunk in request.stream) {
            received += chunk.length;
            sink.add(chunk);
            setState(() {
              progress = received / contentLength;
            });
          }
          await sink.close();
          await tempFile.rename(filePath);
        }
        // ==== image DOWNLOAD ====
        String? localImagePath;
        final imageResponse = await http.get(Uri.parse(widget.track.imageUrl));
        if (imageResponse.statusCode == 200) {
          final imageFile = File('${directory.path}/${widget.track.id}.jpg');
          await imageFile.writeAsBytes(imageResponse.bodyBytes);
          localImagePath = imageFile.path;
        }

        await tracksBox.put(
          widget.track.id,
          TrackHive(
            name: widget.track.name,
            artist: widget.track.artist,
            imageUrl: localImagePath!,
            linkUrl: filePath,
          ),
        );
        widget.track.linkUrl = filePath;
        widget.track.imageUrl = localImagePath;
      } catch (e) {
        final directory = await getApplicationDocumentsDirectory();
        final tempPath = '${directory.path}/${widget.track.id}.mp3.temp';
        final tempFile = File(tempPath);
        if (await tempFile.exists()) {
          await tempFile.delete();
        }
      } finally {
        setState(() {
          isLoading = false;
          widget.track.isDownloaded = true;
        });
      }
    }

    return Scaffold(
        backgroundColor: Colors.grey,
        extendBodyBehindAppBar: true,
        appBar: PlayAudioWidgets.appBar(isLight),
        body: Stack(
          children: [
            PlayAudioWidgets.backGround(
                widget.track.imageUrl, widget.track.isDownloaded),
            BlocBuilder<PlayAudioBloc, PlayAudioState>(
              builder: (context, state) {
                if (state is LoadingPlayAudioState) {
                  return PlayAudioWidgets.loading();
                } else if (state is LoadedAudioState) {
                  return PlayAudioWidgets.loaded(context, state, widget.track,
                      isLoading, progress, () => downloadMp3());
                } else if (state is ErrorAudioState) {
                  return const Center(
                    child: Text('Please try again!'),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ));
  }
}
