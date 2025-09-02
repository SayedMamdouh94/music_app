import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_media/data/hive/track_hive.dart';
import 'package:music_media/view/introduction/introduction.dart';
import 'package:music_media/view_model/home/home_bloc.dart';
import 'package:music_media/view_model/searching/searching_bloc.dart';

import 'data/hive/tracks_box.dart';
import 'view_model/theme/theme_bloc.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TrackHiveAdapter());
  tracksBox = await Hive.openBox<TrackHive>('tracksBox');
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(create: (context) => ThemeCubit()),
        BlocProvider<HomeCubit>(create: (context) => HomeCubit()),
        BlocProvider<SearchingCubit>(create: (context) => SearchingCubit()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'music_media App',
            debugShowCheckedModeBanner: false,
            themeMode: state.themeData,
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              elevatedButtonTheme: const ElevatedButtonThemeData(
                style: ButtonStyle(
                  foregroundColor: WidgetStatePropertyAll<Color>(
                    Colors.white,
                  ),
                ),
              ),
            ),
            theme: ThemeData(
              brightness: Brightness.light,
              elevatedButtonTheme: const ElevatedButtonThemeData(
                style: ButtonStyle(
                  foregroundColor: WidgetStatePropertyAll<Color>(
                    Colors.black,
                  ),
                ),
              ),
            ),
            home: const Introduction(),
          );
        },
      ),
    );
  }
}
