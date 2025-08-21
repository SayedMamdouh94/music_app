import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

import '../../core/constants/const_colors.dart';

class PagesStateWidgets {
  static navigationBar(PageController controller) {
    final List<Widget> iconList = <Widget>[
      const Icon(Icons.home),
      const Icon(Icons.favorite),
      const Icon(Icons.search),
    ];

    return CurvedNavigationBar(
      items: iconList,
      color: ConstColors.red,
      buttonBackgroundColor: ConstColors.red,
      backgroundColor: Colors.transparent,
      height: 60,
      onTap: (index) {
        controller.jumpToPage(index);
      },
    );
  }
}
