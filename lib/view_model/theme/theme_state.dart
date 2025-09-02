part of 'theme_bloc.dart';

sealed class ThemeState {
  final ThemeMode themeData;
  const ThemeState({required this.themeData});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ThemeState && other.themeData == themeData;

  @override
  int get hashCode => themeData.hashCode;
}

final class ThemeLightState extends ThemeState {
  const ThemeLightState() : super(themeData: ThemeMode.light);
}

final class ThemeDarkState extends ThemeState {
  const ThemeDarkState() : super(themeData: ThemeMode.dark);
}

final class ThemeSystemState extends ThemeState {
  const ThemeSystemState() : super(themeData: ThemeMode.system);
}
