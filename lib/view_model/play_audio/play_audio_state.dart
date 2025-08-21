part of 'play_audio_bloc.dart';

@immutable
sealed class PlayAudioState {}

class PlayAudioInitial extends PlayAudioState {}

class LoadingPlayAudioState extends PlayAudioState {}

class LoadedAudioState extends PlayAudioState {
  final Color dominantColor;
  final bool isPlaying;
  final bool isRepeating;
  final Duration duration;
  final Duration position;
  LoadedAudioState({
    required this.dominantColor,
    required this.isPlaying,
    required this.isRepeating,
    required this.duration,
    required this.position,
  });
  LoadedAudioState copyWith({
    Color? dominantColor,
    bool? isPlaying,
    bool? isRepeating,
    Duration? duration,
    Duration? position,
  }) {
    return LoadedAudioState(
      dominantColor: dominantColor ?? this.dominantColor,
      isPlaying: isPlaying ?? this.isPlaying,
      isRepeating: isRepeating ?? this.isRepeating,
      duration: duration ?? this.duration,
      position: position ?? this.position,
    );
  }
}

class ErrorAudioState extends PlayAudioState {}
