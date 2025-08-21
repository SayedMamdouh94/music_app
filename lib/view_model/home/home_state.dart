part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<categor.Category> categories;
  HomeLoaded(this.categories);
}

class HomeError extends HomeState {}
