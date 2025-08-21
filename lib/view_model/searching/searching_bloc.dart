import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../data/service/service.dart';

part 'searching_event.dart';
part 'searching_state.dart';

class SearchingBloc extends Bloc<SearchingEvent, SearchingState> {
  SearchingBloc() : super(SearchingInitial()) {
    on<SearchQueryEvent>(
      (event, emit) async {
        emit(SearchingLoading());
        try {
          final result = await Service().searching(event.query, event.type);

          emit(
            SearchingLoaded(
              tracks: event.type == 'song' ? result : [],
              artists: event.type == 'artist' ? result : [],
              albums: event.type == 'album' ? result : [],
              playlists: event.type == 'playlist' ? result : [],
            ),
          );
        } catch (e) {
          emit(SearchingError());
        }
      },
    );
  }
}
