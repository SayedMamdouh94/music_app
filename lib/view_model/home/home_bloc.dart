import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

import '../../data/model/category.dart' as categor;
import '../../data/service/service.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeInitial());

  Future<void> fetchCategories() async {
    // Only emit loading state if we don't have cached data
    if (state is! HomeLoaded) {
      emit(const HomeLoading());
    }

    try {
      // Add timeout to prevent indefinite loading
      final data = await Service().getCategories().timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw Exception('Request timeout');
        },
      );
      emit(HomeLoaded(data));
    } catch (e) {
      if (kDebugMode) {
        print('HomeCubit error: $e');
      }
      emit(const HomeError());
    }
  }

  void clearCache() {
    Service.clearCache();
    emit(const HomeInitial());
  }
}
