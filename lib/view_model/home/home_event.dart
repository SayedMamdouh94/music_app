part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

class FetchHomeEvent extends HomeEvent {
  FetchHomeEvent();
}
