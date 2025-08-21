part of 'tracks_bloc.dart';

@immutable
sealed class TracksEvent {}

class GetTracksEvent extends TracksEvent {
  final String type;
  final dynamic item;
  GetTracksEvent({required this.type, required this.item});
}

class LoadedEvent extends TracksEvent {}
