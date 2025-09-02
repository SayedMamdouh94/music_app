import 'package:flutter/material.dart';

class CarouselEmptyState extends StatelessWidget {
  final double height;

  const CarouselEmptyState({
    super.key,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height / 4.5,
      child: const Center(
        child: Text(
          'No playlists available',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ),
    );
  }
}
