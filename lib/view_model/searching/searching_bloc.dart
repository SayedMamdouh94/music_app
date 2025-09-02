import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/service/service.dart';

part 'searching_state.dart';

class SearchingCubit extends Cubit<SearchingState> {
  SearchingCubit() : super(const SearchingInitial());

  Future<void> search({required String query, required String type}) async {
    emit(const SearchingLoading());
    try {
      final result = await Service().searching(query, type);

      emit(
        SearchingLoaded(
          tracks: type == 'song' ? result : [],
          artists: type == 'artist' ? result : [],
          albums: type == 'album' ? result : [],
          playlists: type == 'playlist' ? result : [],
        ),
      );
    } catch (e) {
      emit(const SearchingError());
    }
  }

  void clearResults() {
    emit(const SearchingInitial());
  }
}
