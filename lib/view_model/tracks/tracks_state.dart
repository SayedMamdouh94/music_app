part of 'tracks_bloc.dart';

@immutable
sealed class TracksState {}

final class TracksInitial extends TracksState {}

final class TracksLoading extends TracksState {}

final class TracksLoaded extends TracksState {}

final class TracksError extends TracksState {}
