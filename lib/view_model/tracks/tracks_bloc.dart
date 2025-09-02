import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_media/data/service/service.dart';

import '../../data/model/track.dart';

part 'tracks_state.dart';

class TracksCubit extends Cubit<TracksState> {
  TracksCubit() : super(const TracksInitial());

  Future<void> getTracks({required String type, required dynamic item}) async {
    try {
      emit(const TracksLoading());
      final List<Track> tracks = await Service().getTracks(type: type, item.id);
      item.tracks = tracks;
      emit(const TracksLoaded());
    } catch (e) {
      emit(const TracksError());
    }
  }

  void setLoaded() {
    emit(const TracksLoaded());
  }
}
