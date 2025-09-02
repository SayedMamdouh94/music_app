import 'dart:ui';

import 'package:flutter/material.dart';

import '../../core/constants/const_colors.dart';
import '../../data/model/artist.dart';

class ArtistProfileWidgets {
  static sliverAppBar(BuildContext context, Artist artist) {
    return SliverAppBar(
      pinned: true,
      expandedHeight: MediaQuery.of(context).size.height / 3,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          artist.name,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Opacity(
                opacity: 0.7,
                child: Image.network(
                  artist.imageUrl,
                  fit: BoxFit.cover,
                )),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(color: Colors.black.withValues(alpha: 0.1)),
            ),
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 70,
                    backgroundImage: NetworkImage(artist.imageUrl),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static title() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 30, 16, 30),
        child: Text(
          textAlign: TextAlign.center,
          '- - - - Top Songs - - - -',
          style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w100,
              fontFamily: 'Italianno-Regular',
              color: ConstColors.redOp8),
        ),
      ),
    );
  }
}
