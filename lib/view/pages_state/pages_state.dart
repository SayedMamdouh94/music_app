import 'package:flutter/material.dart';
import 'package:music_media/view/favorites/favorites.dart';
import 'package:music_media/view/home/home.dart';
import 'package:music_media/view/pages_state/pages_state_widgets.dart';
import 'package:music_media/view/search/search.dart';

class PagesState extends StatelessWidget {
  PagesState({super.key});
  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: PagesStateWidgets.navigationBar(pageController),
      body: PageView(
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          Home(),
          Favorites(),
          Search(),
        ],
      ),
    );
  }
}
