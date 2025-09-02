import 'package:flutter/material.dart';
import 'package:music_media/core/constants/const_colors.dart';

class CarouselHeader extends StatelessWidget {
  final String title;

  const CarouselHeader({
    super.key,
    this.title = 'Featured Playlists',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Icon(
            Icons.music_note,
            color: ConstColors.red,
            size: 28,
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: ConstColors.red,
            ),
          ),
        ],
      ),
    );
  }
}
