part of 'change_theme_bloc.dart';

abstract class ChangeThemeEvent {}

class DecideTheme extends ChangeThemeEvent {}

class LightTheme extends ChangeThemeEvent {
  @override
  String toString() => 'Light Theme';
}

class DarkTheme extends ChangeThemeEvent {
  @override
  String toString() => 'Dark Theme';
}
