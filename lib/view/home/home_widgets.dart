import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music_media/core/constants/widgets.dart';

import '../../core/constants/const_colors.dart';
import '../../data/model/album.dart';
import '../../data/model/category.dart' as catego;

class HomeWidgets {
  static appBar(bool isLight) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isLight ? Brightness.dark : Brightness.light,
        statusBarBrightness:
            isLight ? Brightness.dark : Brightness.light, // for iOS
      ),
    );
  }

  static categoriesSection(
    double height,
    void Function(List<catego.Category>) allButton,
    void Function(catego.Category) categoriesButton,
    String selectedButton,
    List<catego.Category> allCategories,
    bool isLight,
  ) {
    return SizedBox(
      height: height / 3.5,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          HomeWidgets.stackBackground(height),
          HomeWidgets.stackButtons(
            allButton,
            allCategories,
            categoriesButton,
            selectedButton,
            allCategories,
            isLight,
          ),
        ],
      ),
    );
  }

  static stackWidget(
    double height,
    void Function(List<catego.Category>) allButton,
    void Function(catego.Category) categoriesButton,
    String selectedButton,
    List currentPlaylists,
    List<catego.Category> allCategories,
    PageController pageController,
    bool isLight,
  ) {
    return SizedBox(
      height: height / 2.2,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          HomeWidgets.stackBackground(height),
          HomeWidgets.stackButtons(
            allButton,
            allCategories,
            categoriesButton,
            selectedButton,
            allCategories,
            isLight,
          ),
          HomeWidgets.stackPlaylist(
            height,
            pageController,
            currentPlaylists,
          ),
        ],
      ),
    );
  }

  static title(String title) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 60,
          fontWeight: FontWeight.w900,
          fontFamily: 'Italianno-Regular',
          color: ConstColors.red,
        ),
      ),
    );
  }

  static artistsWidget(List listArtist) {
    return SizedBox(
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: listArtist.length,
        itemBuilder: (context, index) {
          final artist = listArtist[index];
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            width: 100,
            height: 150,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Widgets.artistWidget(artist, context),
                Text(
                  artist.name,
                  style: const TextStyle(fontSize: 15),
                  overflow: TextOverflow.ellipsis,
                )
              ],
            ),
          );
        },
      ),
    );
  }

  static albumsWidget(List<Album> listAlbums) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 5,
        mainAxisSpacing: 15,
        childAspectRatio: 0.75,
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: listAlbums.length,
      itemBuilder: (context, index) {
        final album = listAlbums[index];
        return Widgets.albumWidget(album, context);
      },
    );
  }

  //----------------------------------------------------------------------------

  static stackBackground(h) {
    return Container(
      height: h / 3,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ConstColors.red,
            ConstColors.cream,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }

  static stackButtons(ab, ac, cb, sb, acl, isLight) {
    return Positioned(
      top: 110,
      left: 0,
      right: 0,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            child: ElevatedButton(
              onPressed: () => ab(ac),
              style: ElevatedButton.styleFrom(
                side: BorderSide(color: ConstColors.cream, width: 1),
                backgroundColor: sb == 'All'
                    ? ConstColors.red
                    : isLight
                        ? Colors.white
                        : Colors.black,
              ),
              child: const Text('All'),
            ),
          ),
          ...acl.map((cat) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                child: ElevatedButton(
                    onPressed: () => cb(cat),
                    style: ElevatedButton.styleFrom(
                      side: BorderSide(color: ConstColors.cream, width: 1),
                      backgroundColor: sb == cat.name
                          ? ConstColors.red
                          : isLight
                              ? Colors.white
                              : Colors.black,
                    ),
                    child: Text(cat.name)),
              )),
        ]),
      ),
    );
  }

  static stackPlaylist(h, pc, currentPlay) {
    return Positioned(
      top: 170,
      left: 0,
      right: 0,
      child: SizedBox(
          height: h / 4.5,
          child: PageView.builder(
            controller: pc,
            itemCount: currentPlay.length,
            itemBuilder: (context, index) {
              return AnimatedBuilder(
                animation: pc,
                builder: (BuildContext context, Widget? child) {
                  double value = 1;
                  if (pc.position.haveDimensions) {
                    value = (pc.page! - index).abs();
                    value = (1 - value).clamp(0.8, 1.0);
                  }

                  return Transform.scale(
                    scale: Curves.easeOut.transform(value),
                    child: Opacity(
                      opacity: value,
                      child:
                          Widgets.playlistWidget(currentPlay[index], context),
                    ),
                  );
                },
              );
            },
          )),
    );
  }
}
