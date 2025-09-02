import 'package:flutter/material.dart';
import 'package:music_media/core/constants/widgets.dart';
import 'package:music_media/core/constants/const_colors.dart';

class CarouselItem extends StatelessWidget {
  final dynamic playlist;
  final double scale;
  final bool isActive;

  const CarouselItem({
    super.key,
    required this.playlist,
    required this.scale,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: scale,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isActive ? 0.3 : 0.1),
              blurRadius: isActive ? 15 : 8,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isActive
                  ? [
                      ConstColors.red.withValues(alpha: 0.1),
                      ConstColors.cream.withValues(alpha: 0.1),
                    ]
                  : [
                      Colors.grey.withValues(alpha: 0.05),
                      Colors.grey.withValues(alpha: 0.05),
                    ],
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                // Main playlist widget
                Widgets.playlistWidget(playlist, context),

                // Overlay for active item
                if (isActive) _buildActiveOverlay(),

                // Floating play button for active item
                if (isActive) _buildPlayButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActiveOverlay() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: ConstColors.red.withValues(alpha: 0.5),
          width: 2,
        ),
      ),
    );
  }

  Widget _buildPlayButton() {
    return Positioned(
      bottom: 15,
      right: 15,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: ConstColors.red,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: ConstColors.red.withValues(alpha: 0.4),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: const Icon(
          Icons.play_arrow,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }
}
