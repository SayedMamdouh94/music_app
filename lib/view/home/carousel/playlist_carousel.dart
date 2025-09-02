import 'package:flutter/material.dart';
import 'carousel_item.dart';
import 'carousel_indicators.dart';
import 'carousel_empty_state.dart';

class PlaylistCarousel extends StatefulWidget {
  final List<dynamic> playlists;
  final double height;

  const PlaylistCarousel({
    super.key,
    required this.playlists,
    required this.height,
  });

  @override
  State<PlaylistCarousel> createState() => _PlaylistCarouselState();
}

class _PlaylistCarouselState extends State<PlaylistCarousel>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  int _currentIndex = 500000; // Start in the middle to match initialPage

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _startAnimation();
  }

  void _initializeControllers() {
    _pageController = PageController(
      viewportFraction: 0.85,
      initialPage:
          500000, // Start in the middle for infinite scrolling both ways
    );

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  void _startAnimation() {
    _animationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.playlists.isEmpty) {
      return CarouselEmptyState(height: widget.height);
    }

    return Container(
      height: widget.height / 4.5,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        children: [
          // Carousel indicators
          CarouselIndicators(
            itemCount: widget.playlists.length,
            currentIndex: _currentIndex,
          ),
          const SizedBox(height: 15),

          // Main carousel
          Expanded(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: PageView.builder(
                controller: _pageController,
                itemCount:
                    1000000, // Very large number for pseudo-infinite scrolling
                onPageChanged: _onPageChanged,
                itemBuilder: _buildCarouselPage,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget _buildCarouselPage(BuildContext context, int index) {
    // Handle infinite carousel by using modulo to get the actual playlist index
    int actualIndex = index % widget.playlists.length;

    return AnimatedBuilder(
      animation: _pageController,
      builder: (context, child) {
        double value = _calculateScaleValue(index);
        bool isActive = index == _currentIndex;

        return CarouselItem(
          playlist: widget.playlists[actualIndex],
          scale: value,
          isActive: isActive,
        );
      },
    );
  }

  double _calculateScaleValue(int index) {
    double value = 1.0;
    if (_pageController.position.haveDimensions) {
      value = (_pageController.page! - index).abs();
      value = (1.0 - (value * 0.3)).clamp(0.7, 1.0);
    }
    return value;
  }
}
