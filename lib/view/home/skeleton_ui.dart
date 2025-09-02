import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonUI extends StatelessWidget {
  const SkeletonUI({super.key});

  Widget shimmerBox(
      {double height = 20, double width = double.infinity, double radius = 8}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade800,
      highlightColor: Colors.grey.shade600,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.grey.shade800,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 100, 16, 16),
        scrollDirection: Axis.vertical,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              3,
              (_) => shimmerBox(height: 40, width: 100, radius: 20),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 160,
            child: PageView.builder(
              controller: PageController(viewportFraction: 0.8),
              itemCount: 3,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: shimmerBox(height: 160, radius: 20),
              ),
            ),
          ),
          const SizedBox(height: 40),
          Align(
            alignment: Alignment.centerLeft,
            child: shimmerBox(height: 20, width: 250),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              3,
              (_) => Column(
                children: [
                  shimmerBox(height: 80, width: 80, radius: 50),
                  const SizedBox(height: 10),
                  shimmerBox(height: 10, width: 50, radius: 20),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerLeft,
            child: shimmerBox(height: 20, width: 250),
          ),
          GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 5,
              mainAxisSpacing: 15,
              childAspectRatio: 0.75,
            ),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 6,
            itemBuilder: (context, index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  shimmerBox(height: 200, radius: 16),
                  const SizedBox(height: 8),
                  shimmerBox(height: 12, width: 120, radius: 8),
                ],
              );
            },
          )
        ],
      ),
    );
  }
}
