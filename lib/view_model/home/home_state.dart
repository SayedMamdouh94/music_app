part of 'home_bloc.dart';

sealed class HomeState {
  const HomeState();
}

final class HomeInitial extends HomeState {
  const HomeInitial();
}

final class HomeLoading extends HomeState {
  const HomeLoading();
}

final class HomeLoaded extends HomeState {
  final List<categor.Category> categories;

  const HomeLoaded(this.categories);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HomeLoaded && other.categories == categories;

  @override
  int get hashCode => categories.hashCode;
}

final class HomeError extends HomeState {
  const HomeError();
}
