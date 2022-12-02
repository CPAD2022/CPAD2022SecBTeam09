import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:news/src/constants/ColorConstants.dart';
import 'package:news/src/utils/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

part 'change_theme_event.dart';

part 'change_theme_state.dart';

class ChangeThemeBloc extends Bloc<ChangeThemeEvent, ChangeThemeState> {
  void onLightThemeChange() => add(LightTheme());

  void onDarkThemeChange() => add(DarkTheme());

  void onDecideThemeChange() => add(DecideTheme());

  ChangeThemeBloc() : super(ChangeThemeState.lightTheme());

  @override
  Stream<ChangeThemeState> mapEventToState(ChangeThemeEvent event) async* {
    if (event is DecideTheme) {
      final int optionValue = await getOption();

      if (optionValue == 0) {
        yield ChangeThemeState.lightTheme();
        ColorConstants.setLightColors();
      } else if (optionValue == 1) {
        yield ChangeThemeState.darkTheme();
        ColorConstants.setDarkColors();
      }
    }

    if (event is DarkTheme) {
      yield ChangeThemeState.darkTheme();
      try {
        _saveOptionValue(1);
        ColorConstants.setDarkColors();
      } catch (_) {
        throw Exception("Could not persist change");
      }
    }

    if (event is LightTheme) {
      yield ChangeThemeState.lightTheme();
      try {
        _saveOptionValue(0);
        ColorConstants.setLightColors();
      } catch (_) {
        throw Exception("Could not persist change");
      }
    }
  }

  Future<void> _saveOptionValue(int optionValue) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt('theme_option', optionValue);
  }

  Future<int> getOption() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int option = preferences.get('theme_option') ?? 0;
    return option;
  }
}
