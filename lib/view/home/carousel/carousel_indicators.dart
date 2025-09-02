import 'package:flutter/material.dart';
import 'package:music_media/core/constants/const_colors.dart';

class CarouselIndicators extends StatelessWidget {
  final int itemCount;
  final int currentIndex; 

  const CarouselIndicators({
    super.key,
    required this.itemCount,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    int actualCurrentIndex = currentIndex % itemCount;
    if (itemCount <= 8) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(itemCount, (index) {
          bool isActive = index == actualCurrentIndex;
          return _buildIndicator(isActive);
        }),
      );
    }
    return _buildProgressIndicator(actualCurrentIndex);
  }

  Widget _buildProgressIndicator(int currentPosition) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: ConstColors.red.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '${currentPosition + 1} / $itemCount',
            style: TextStyle(
              color: ConstColors.red,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIndicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 3),
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color:
            isActive ? ConstColors.red : ConstColors.red.withValues(alpha: 0.3),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: ConstColors.red.withValues(alpha: 0.4),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
    );
  }
}
