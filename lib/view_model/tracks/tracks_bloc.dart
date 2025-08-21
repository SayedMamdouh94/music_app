import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:music_media/data/service/service.dart';

import '../../data/model/track.dart';

part 'tracks_event.dart';
part 'tracks_state.dart';

class TracksBloc extends Bloc<TracksEvent, TracksState> {
  TracksBloc() : super(TracksInitial()) {
    on<GetTracksEvent>((event, emit) async {
      try {
        emit(TracksLoading());
        final List<Track> tracks =
            await Service().getTracks(type: event.type, event.item.id);
        event.item.tracks = tracks;
        emit(TracksLoaded());
      } catch (e) {
        emit(TracksError());
      }
    });
    on<LoadedEvent>((event, emit) {
      emit(TracksLoaded());
    });
  }
}
