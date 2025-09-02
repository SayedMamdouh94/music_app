part of 'play_audio_bloc.dart';

sealed class PlayAudioState {
  const PlayAudioState();
}

final class PlayAudioInitial extends PlayAudioState {
  const PlayAudioInitial();
}

final class LoadingPlayAudioState extends PlayAudioState {
  const LoadingPlayAudioState();
}

final class LoadedAudioState extends PlayAudioState {
  final Color dominantColor;
  final bool isPlaying;
  final bool isRepeating;
  final Duration duration;
  final Duration position;

  const LoadedAudioState({
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoadedAudioState &&
          other.dominantColor == dominantColor &&
          other.isPlaying == isPlaying &&
          other.isRepeating == isRepeating &&
          other.duration == duration &&
          other.position == position;

  @override
  int get hashCode => Object.hash(
        dominantColor,
        isPlaying,
        isRepeating,
        duration,
        position,
      );
}

final class ErrorAudioState extends PlayAudioState {
  const ErrorAudioState();
}
