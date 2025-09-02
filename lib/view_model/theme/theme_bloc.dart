import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(const ThemeSystemState());

  void toggleTheme(Brightness currentBrightness) {
    if (currentBrightness == Brightness.light) {
      emit(const ThemeDarkState());
    } else {
      emit(const ThemeLightState());
    }
  }

  void setTheme(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        emit(const ThemeLightState());
        break;
      case ThemeMode.dark:
        emit(const ThemeDarkState());
        break;
      case ThemeMode.system:
        emit(const ThemeSystemState());
        break;
    }
  }
}
