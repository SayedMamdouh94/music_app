import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:palette_generator/palette_generator.dart';

part 'play_audio_event.dart';
part 'play_audio_state.dart';

class PlayAudioBloc extends Bloc<PlayAudioEvent, PlayAudioState> {
  final AudioPlayer audioPlayer = AudioPlayer();
  PlayAudioBloc() : super(PlayAudioInitial()) {
    on<LoadAudioEvent>(loadAudio);
    on<SeekAudioEvent>(seekAudio);
    on<PlayPauseEvent>(playPause);
    on<ToggleRepeatEvent>(toggleRepeat);
    on<JumpForwardEvent>(jumpForward);
    on<JumpBackEvent>(jumpBack);
    on<ListenPositionEvent>((event, emit) {
      if (state is LoadedAudioState) {
        final currentState = state as LoadedAudioState;
        if (event.position >= currentState.duration &&
            audioPlayer.loopMode == LoopMode.off) {
          audioPlayer.pause();
          add(SeekAudioEvent(position: Duration.zero));

          emit(
              currentState.copyWith(position: Duration.zero, isPlaying: false));
          return;
        }
        emit(currentState.copyWith(position: event.position));
      }
    });
  }
  void loadAudio(LoadAudioEvent event, Emitter<PlayAudioState> emit) async {
    emit(LoadingPlayAudioState());
    try {
      if (event.isDownloaded) {
        await audioPlayer.setFilePath(event.audioUrl);
      } else {
        await audioPlayer.setUrl(event.audioUrl);
      }
      final PaletteGenerator palette = await PaletteGenerator.fromImageProvider(
        event.isDownloaded
            ? FileImage(File(event.imageUrl))
            : NetworkImage(event.imageUrl),
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
      audioPlayer.positionStream.listen((p) {
        add(ListenPositionEvent(position: p));
      });
    } catch (e) {
      emit(ErrorAudioState());
    }
  }

  void seekAudio(SeekAudioEvent event, Emitter<PlayAudioState> emit) {
    final currentState = state as LoadedAudioState;
    final Duration position = event.position;
    final Duration duration = currentState.duration;
    final Duration newSeconds;
    if (position.inSeconds < 0) {
      newSeconds = Duration.zero;
    } else if (position.inSeconds > duration.inSeconds) {
      newSeconds = duration;
    } else {
      newSeconds = position;
    }
    audioPlayer.seek(newSeconds);
    emit(currentState.copyWith(position: newSeconds));
  }

  void playPause(PlayPauseEvent event, Emitter<PlayAudioState> emit) {
    final currentState = state as LoadedAudioState;
    currentState.isPlaying ? audioPlayer.pause() : audioPlayer.play();
    emit(currentState.copyWith(isPlaying: !currentState.isPlaying));
  }

  void toggleRepeat(ToggleRepeatEvent event, Emitter<PlayAudioState> emit) {
    final currentState = state as LoadedAudioState;
    final bool isRepeating = currentState.isRepeating;
    audioPlayer.setLoopMode(isRepeating ? LoopMode.off : LoopMode.all);
    emit(currentState.copyWith(isRepeating: !isRepeating));
  }

  void jumpForward(JumpForwardEvent event, Emitter<PlayAudioState> emit) {
    final currentState = state as LoadedAudioState;
    add(SeekAudioEvent(
        position: currentState.position + const Duration(seconds: 10)));
  }

  void jumpBack(JumpBackEvent event, Emitter<PlayAudioState> emit) {
    final currentState = state as LoadedAudioState;
    add(SeekAudioEvent(
        position: currentState.position - const Duration(seconds: 10)));
  }

  @override
  Future<void> close() {
    audioPlayer.dispose();
    return super.close();
  }
}
