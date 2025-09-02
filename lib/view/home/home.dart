import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_media/data/model/album.dart';
import 'package:music_media/data/model/artist.dart';
import 'package:music_media/data/model/category.dart' as categor;
import 'package:music_media/data/model/playlist.dart';
import 'package:music_media/view/home/home_widgets.dart';
import 'package:music_media/view/home/skeleton_ui.dart';
import 'package:music_media/view/home/carousel/carousel_section.dart';

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
    super.initState();
    final state = context.read<HomeCubit>().state;
    if (state is! HomeLoaded) {
      context.read<HomeCubit>().fetchCategories();
    }
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
    context.read<HomeCubit>().fetchCategories();
    // Reduced delay for better UX
    await Future.delayed(const Duration(milliseconds: 300));
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final isLight = Theme.of(context).brightness == Brightness.light;

    return Scaffold(
      appBar: HomeWidgets.appBar(isLight),
      extendBodyBehindAppBar: true,
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: BlocBuilder<HomeCubit, HomeState>(
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
                  HomeWidgets.categoriesSection(
                      height,
                      allButton,
                      categoriesButton,
                      selectedButton,
                      state.categories,
                      isLight),

                  // Beautiful Carousel Section
                  CarouselSection(
                    playlists: currentPlaylists,
                    height: height,
                    title: 'Featured Playlists',
                  ),

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
