import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(const ThemeState(themeData: ThemeMode.system)) {
    on<ThemeEvent>((event, emit) {
      if (event.brightness == Brightness.light) {
        emit(const ThemeState(themeData: ThemeMode.dark));
      } else {
        emit(const ThemeState(themeData: ThemeMode.light));
      }
    });
  }
}
