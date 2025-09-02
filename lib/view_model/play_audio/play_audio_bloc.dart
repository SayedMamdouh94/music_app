import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:palette_generator/palette_generator.dart';

part 'play_audio_state.dart';

class PlayAudioCubit extends Cubit<PlayAudioState> {
  final AudioPlayer audioPlayer = AudioPlayer();

  PlayAudioCubit() : super(const PlayAudioInitial());

  Future<void> loadAudio({
    required bool isDownloaded,
    required String audioUrl,
    required String imageUrl,
  }) async {
    emit(const LoadingPlayAudioState());
    try {
      if (isDownloaded) {
        await audioPlayer.setFilePath(audioUrl);
      } else {
        await audioPlayer.setUrl(audioUrl);
      }

      final PaletteGenerator palette = await PaletteGenerator.fromImageProvider(
        isDownloaded ? FileImage(File(imageUrl)) : NetworkImage(imageUrl),
      );
      final dominantColor = palette.darkVibrantColor?.color ?? Colors.black;

      emit(LoadedAudioState(
        dominantColor: dominantColor,
        isPlaying: true,
        isRepeating: false,
        position: Duration.zero,
        duration: audioPlayer.duration ?? Duration.zero,
      ));

      audioPlayer.play();
      audioPlayer.setLoopMode(LoopMode.off);

      // Listen to position changes
      audioPlayer.positionStream.listen((position) {
        updatePosition(position);
      });
    } catch (e) {
      emit(const ErrorAudioState());
    }
  }

  void updatePosition(Duration position) {
    if (state is LoadedAudioState) {
      final currentState = state as LoadedAudioState;
      if (position >= currentState.duration &&
          audioPlayer.loopMode == LoopMode.off) {
        audioPlayer.pause();
        seekAudio(Duration.zero);
        emit(currentState.copyWith(position: Duration.zero, isPlaying: false));
        return;
      }
      emit(currentState.copyWith(position: position));
    }
  }

  void seekAudio(Duration position) {
    if (state is LoadedAudioState) {
      final currentState = state as LoadedAudioState;
      final Duration duration = currentState.duration;
      final Duration newPosition;

      if (position.inSeconds < 0) {
        newPosition = Duration.zero;
      } else if (position.inSeconds > duration.inSeconds) {
        newPosition = duration;
      } else {
        newPosition = position;
      }

      audioPlayer.seek(newPosition);
      emit(currentState.copyWith(position: newPosition));
    }
  }

  void playPause() {
    if (state is LoadedAudioState) {
      final currentState = state as LoadedAudioState;
      currentState.isPlaying ? audioPlayer.pause() : audioPlayer.play();
      emit(currentState.copyWith(isPlaying: !currentState.isPlaying));
    }
  }

  void toggleRepeat() {
    if (state is LoadedAudioState) {
      final currentState = state as LoadedAudioState;
      final bool isRepeating = currentState.isRepeating;
      audioPlayer.setLoopMode(isRepeating ? LoopMode.off : LoopMode.all);
      emit(currentState.copyWith(isRepeating: !isRepeating));
    }
  }

  void jumpForward() {
    if (state is LoadedAudioState) {
      final currentState = state as LoadedAudioState;
      seekAudio(currentState.position + const Duration(seconds: 10));
    }
  }

  void jumpBack() {
    if (state is LoadedAudioState) {
      final currentState = state as LoadedAudioState;
      seekAudio(currentState.position - const Duration(seconds: 10));
    }
  }

  @override
  Future<void> close() {
    audioPlayer.dispose();
    return super.close();
  }
}
