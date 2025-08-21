import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

import '../../data/model/category.dart' as categor;
import '../../data/service/service.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<FetchHomeEvent>((event, emit) async {
      emit(HomeLoading());
      try {
        final data = await Service().getCategories();
        emit(HomeLoaded(data));
      } catch (e) {
        emit(HomeError());
      }
    });
  }
}
