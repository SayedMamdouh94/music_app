import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/model/track.dart';
import '../../view_model/play_audio/play_audio_bloc.dart';

class PlayAudioWidgets {
  static String formatTime(Duration time) {
    return '${time.inMinutes}:${(time.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  static appBar(bool isLight) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isLight
            ? Brightness.dark
            : Brightness.light, // for dark backgrounds
        statusBarBrightness:
            isLight ? Brightness.dark : Brightness.light, // for iOS
      ),
    );
  }

  static backGround(String imageUrl, bool isDownload) {
    return Opacity(
      opacity: 0.4,
      child: isDownload
          ? Image.file(
              File(imageUrl),
              fit: BoxFit.fill,
              width: double.infinity,
              height: double.infinity,
              errorBuilder: (context, error, stackTrace) => const Center(
                child: Text("Image failed to load"),
              ),
            )
          : Image.network(
              imageUrl,
              fit: BoxFit.fill,
              width: double.infinity,
              height: double.infinity,
              errorBuilder: (context, error, stackTrace) => const Center(
                child: Text("Image failed to load"),
              ),
            ),
    );
  }

  static loading() {
    return const Center(
      child: CircularProgressIndicator(
        color: Colors.black,
      ),
    );
  }

  static loaded(BuildContext context, state, Track track, bool isLoading,
      double progress, Future<void> Function() download) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView(
        children: [
          Container(
            height: 300,
            width: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(width: 3, color: state.dominantColor),
              boxShadow: [
                BoxShadow(
                  color: state.dominantColor.withOpacity(0.6),
                  blurRadius: 30,
                  spreadRadius: 10,
                ),
              ],
              image: DecorationImage(
                  image: track.isDownloaded
                      ? FileImage(File(track.imageUrl))
                      : NetworkImage(track.imageUrl)),
            ),
          ),
          Text(
            textAlign: TextAlign.center,
            track.name,
            style: TextStyle(
                color: state.dominantColor,
                fontSize: 40,
                fontWeight: FontWeight.bold,
                fontFamily: 'Italianno-Regular'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              track.isDownloaded
                  ? Icon(
                      Icons.check,
                      size: 50,
                      color: state.dominantColor,
                    )
                  : isLoading
                      ? Container(
                          padding: const EdgeInsets.only(top: 15),
                          width: 80,
                          child: Column(
                            children: [
                              LinearProgressIndicator(
                                value: progress,
                                minHeight: 15,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  state.dominantColor,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "${(progress * 100).toStringAsFixed(0)}%",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        )
                      : IconButton(
                          onPressed: () => download(),
                          icon: Icon(
                            Icons.download,
                            size: 40,
                            color: state.dominantColor,
                          ),
                        ),
              IconButton(
                onPressed: () =>
                    {context.read<PlayAudioCubit>().toggleRepeat()},
                icon: Icon(
                  state.isRepeating ? Icons.repeat : Icons.repeat_one,
                  size: 50,
                  color: state.dominantColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: state.dominantColor.withOpacity(0.3),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 15),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      formatTime(state.position),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white70,
                      ),
                    ),
                    Text(
                      formatTime(state.duration),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
                Slider(
                  min: 0.0,
                  max: state.duration.inSeconds.toDouble(),
                  value: state.position.inSeconds
                      .clamp(0, state.duration.inSeconds)
                      .toDouble(),
                  activeColor: state.dominantColor,
                  inactiveColor: Colors.white24,
                  onChanged: (value) {
                    context.read<PlayAudioCubit>().seekAudio(
                          Duration(seconds: value.toInt()),
                        );
                  },
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: () =>
                          context.read<PlayAudioCubit>().jumpBack(),
                      icon: const Icon(
                        Icons.replay_10,
                        size: 40,
                        color: Colors.white70,
                      ),
                    ),
                    IconButton(
                      onPressed: () =>
                          context.read<PlayAudioCubit>().playPause(),
                      icon: Icon(
                        state.isPlaying ? Icons.pause : Icons.play_arrow,
                        size: 40,
                        color: Colors.white70,
                      ),
                    ),
                    IconButton(
                      onPressed: () =>
                          context.read<PlayAudioCubit>().jumpForward(),
                      icon: const Icon(
                        Icons.forward_10,
                        size: 40,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
