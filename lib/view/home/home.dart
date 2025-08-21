import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_media/data/model/album.dart';
import 'package:music_media/data/model/artist.dart';
import 'package:music_media/data/model/category.dart' as categor;
import 'package:music_media/data/model/playlist.dart';
import 'package:music_media/view/home/home_widgets.dart';
import 'package:music_media/view/home/skeletonUI.dart';

import '../../view_model/home/home_bloc.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Playlist> currentPlaylists = [];
  List<Artist> currentArtists = [];
  List<Album> currentAlbums = [];

  String selectedButton = 'All';

  @override
  void initState() {
    final state = context.read<HomeBloc>().state;
    if (state is! HomeLoaded) {
      context.read<HomeBloc>().add(FetchHomeEvent());
    }
    super.initState();
  }

  void allButton(List<categor.Category> categories) {
    setState(
      () {
        selectedButton = 'All';
        currentPlaylists = categories.expand((cat) => cat.playlists).toList();
        currentArtists = categories.expand((cat) => cat.artists).toList();
        currentAlbums = categories.expand((cat) => cat.albums).toList();
      },
    );
  }

  void categoriesButton(categor.Category cat) {
    setState(() {
      selectedButton = cat.name;
      currentPlaylists = cat.playlists;
      currentArtists = cat.artists;
      currentAlbums = cat.albums;
    });
  }

  Future<void> _onRefresh() async {
    context.read<HomeBloc>().add(FetchHomeEvent());
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final isLight = Theme.of(context).brightness == Brightness.light;
    final PageController pageController =
        PageController(viewportFraction: 0.85);

    return Scaffold(
      appBar: HomeWidgets.appBar(isLight),
      extendBodyBehindAppBar: true,
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return const SkeletonUI();
            } else if (state is HomeLoaded) {
              if (selectedButton == 'All') {
                currentPlaylists =
                    state.categories.expand((cat) => cat.playlists).toList();
                currentArtists =
                    state.categories.expand((cat) => cat.artists).toList();
                currentAlbums =
                    state.categories.expand((cat) => cat.albums).toList();
              }
              return ListView(
                padding: const EdgeInsets.only(bottom: 20),
                children: [
                  HomeWidgets.stackWidget(
                      height,
                      allButton,
                      categoriesButton,
                      selectedButton,
                      currentPlaylists,
                      state.categories,
                      pageController,
                      isLight),
                  HomeWidgets.title('Current Artists'),
                  HomeWidgets.artistsWidget(currentArtists),
                  HomeWidgets.title('Current Albums'),
                  HomeWidgets.albumsWidget(currentAlbums),
                ],
              );
            } else if (state is HomeError) {
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: const Center(child: Text("Please try again!")),
                ),
              );
            } else {
              return const Center(
                child: Text('Failed to load tracks'),
              );
            }
          },
        ),
      ),
    );
  }
}
