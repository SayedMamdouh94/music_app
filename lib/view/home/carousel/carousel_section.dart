import 'package:flutter/material.dart';
import 'carousel_header.dart';
import 'playlist_carousel.dart';

class CarouselSection extends StatelessWidget {
  final List<dynamic> playlists;
  final double height;
  final String title;

  const CarouselSection({
    super.key,
    required this.playlists,
    required this.height,
    this.title = 'Featured Playlists',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        CarouselHeader(title: title),

        // Carousel widget
        PlaylistCarousel(
          playlists: playlists,
          height: height,
        ),
      ],
    );
  }
}
