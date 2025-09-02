part of 'tracks_bloc.dart';

sealed class TracksState {
  const TracksState();
}

final class TracksInitial extends TracksState {
  const TracksInitial();
}

final class TracksLoading extends TracksState {
  const TracksLoading();
}

final class TracksLoaded extends TracksState {
  const TracksLoaded();
}

final class TracksError extends TracksState {
  const TracksError();
}
