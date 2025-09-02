part of 'searching_bloc.dart';

sealed class SearchingState {
  const SearchingState();
}

final class SearchingInitial extends SearchingState {
  const SearchingInitial();
}

final class SearchingLoading extends SearchingState {
  const SearchingLoading();
}

final class SearchingLoaded extends SearchingState {
  final List tracks;
  final List artists;
  final List albums;
  final List playlists;

  const SearchingLoaded({
    required this.tracks,
    required this.artists,
    required this.albums,
    required this.playlists,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SearchingLoaded &&
          other.tracks == tracks &&
          other.artists == artists &&
          other.albums == albums &&
          other.playlists == playlists;

  @override
  int get hashCode => Object.hash(tracks, artists, albums, playlists);
}

final class SearchingError extends SearchingState {
  const SearchingError();
}
