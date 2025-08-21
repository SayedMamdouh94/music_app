part of 'searching_bloc.dart';

@immutable
sealed class SearchingState {}

final class SearchingInitial extends SearchingState {}

class SearchingLoading extends SearchingState {}

class SearchingLoaded extends SearchingState {
  final List tracks;
  final List artists;
  final List albums;
  final List playlists;

  SearchingLoaded({
    required this.tracks,
    required this.artists,
    required this.albums,
    required this.playlists,
  });
}

class SearchingError extends SearchingState {}
