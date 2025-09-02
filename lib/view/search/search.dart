import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_media/view/search/search_widgets.dart';

import '../../view_model/searching/searching_bloc.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String selectedType = "song"; // default
  final TextEditingController controller = TextEditingController();

  void onSearch() {
    final query = controller.text.trim();
    if (query.isNotEmpty) {
      context.read<SearchingCubit>().search(query: query, type: selectedType);
    }
  }

  void onChange(String? value) {
    setState(() => selectedType = value!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          SearchWidgets.appBar(controller, selectedType, onSearch, onChange),
      body: BlocBuilder<SearchingCubit, SearchingState>(
        builder: (context, state) {
          if (state is SearchingLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SearchingLoaded) {
            if (selectedType == "song") {
              return SearchWidgets.listTracks(state.tracks);
            } else if (selectedType == "artist") {
              return SearchWidgets.listArtist(state.artists);
            } else if (selectedType == "album") {
              return SearchWidgets.listAlbums(state.albums);
            } else if (selectedType == "playlist") {
              return SearchWidgets.listPlaylists(state.playlists);
            }
            return const Text('');
          } else if (state is SearchingError) {
            return const Center(child: Text('Please try again !'));
          } else {
            return const Center(child: Text("Search for something..."));
          }
        },
      ),
    );
  }
}
