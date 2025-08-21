import 'package:flutter/material.dart';

import 'intro_Widgets.dart';

class Introduction extends StatefulWidget {
  const Introduction({super.key});
  @override
  State<Introduction> createState() => _IntroductionState();
}

class _IntroductionState extends State<Introduction> {
  PageController pageController = PageController();
  int currentPage = 0;
  List<Map<String, String>> introData = [
    {
      'title': 'Welcome to MusicMedia',
      'description':
          'Play your favorite music with a beautiful UI and smooth experience.',
      'image': 'assets/introduction/intro1.png'
    },
    {
      'title': 'Offline & Online',
      'description':
          'Group your favorite songs and enjoy organized music playback.',
      'image': 'assets/introduction/intro2.png'
    },
    {
      'title': 'Millions of artists',
      'description':
          'Enjoy offline music or explore artists via Deezer integration.',
      'image': 'assets/introduction/intro3.png'
    },
  ];
  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: IntroWidgets.appBar(isLight),
      body: PageView.builder(
        onPageChanged: (current) {
          setState(() {
            currentPage = current;
          });
        },
        controller: pageController,
        itemCount: introData.length,
        itemBuilder: (context, index) {
          return Stack(
            children: [
              IntroWidgets.opacity(introData[index]['image']!),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IntroWidgets.imageIntro(introData[index]['image']!),
                    const SizedBox(height: 50),
                    IntroWidgets.title(introData[index]['title']!),
                    const SizedBox(height: 10),
                    IntroWidgets.supTitle(introData[index]['description']!),
                    const SizedBox(height: 80),
                    IntroWidgets.smooth(pageController, introData.length),
                    const SizedBox(height: 10),
                    IntroWidgets.button(
                        context, pageController, introData.length, currentPage)
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
