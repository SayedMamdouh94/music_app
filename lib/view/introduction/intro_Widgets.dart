import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music_media/core/constants/const_colors.dart';
import 'package:music_media/view/pages_state/pages_state.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class IntroWidgets {
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

  static opacity(String imagePath) {
    return Opacity(
      opacity: 0.1,
      child: Image.asset(
        imagePath,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      ),
    );
  }

  static imageIntro(String imagePath) {
    return Container(
      height: 250,
      width: 250,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            ConstColors.creamOp2,
            ConstColors.red,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: ConstColors.creamOp2,
            blurRadius: 40,
            spreadRadius: 10,
          ),
        ],
      ),
      child: ClipOval(
        child: Image.asset(
          imagePath,
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  static title(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    );
  }

  static supTitle(String supTitle) {
    return Text(
      supTitle,
      style: const TextStyle(
        fontSize: 16,
        color: Colors.grey,
      ),
      textAlign: TextAlign.center,
    );
  }

  static smooth(PageController controller, int count) {
    return SmoothPageIndicator(
      controller: controller, // PageController
      count: count,
      effect: WormEffect(
        activeDotColor: ConstColors.redOp8,
      ),
      onDotClicked: (index) {},
    );
  }

  static button(BuildContext context, PageController controller, int length,
      int currentPage) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (currentPage == length - 1) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => PagesState()));
          } else {
            controller.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.linear,
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: ConstColors.red,
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(
          currentPage == length - 1 ? 'Get Started' : 'Next',
        ),
      ),
    );
  }
}
