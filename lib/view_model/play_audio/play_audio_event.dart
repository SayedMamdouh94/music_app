part of 'play_audio_bloc.dart';

@immutable
sealed class PlayAudioEvent {}

class LoadAudioEvent extends PlayAudioEvent {
  final bool isDownloaded;
  final String audioUrl;
  final String imageUrl;
  LoadAudioEvent({
    required this.isDownloaded,
    required this.audioUrl,
    required this.imageUrl,
  });
}

class SeekAudioEvent extends PlayAudioEvent {
  final Duration position;
  SeekAudioEvent({required this.position});
}

class ListenPositionEvent extends PlayAudioEvent {
  final Duration position;
  ListenPositionEvent({required this.position});
}

class PlayPauseEvent extends PlayAudioEvent {}

class ToggleRepeatEvent extends PlayAudioEvent {}

class JumpForwardEvent extends PlayAudioEvent {}

class JumpBackEvent extends PlayAudioEvent {}
