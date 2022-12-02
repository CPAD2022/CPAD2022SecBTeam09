import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:news/src/constants/enums.dart';
import 'package:news/src/utils/shared_preferences_language_service.dart';
import 'package:flutter/material.dart';
part 'language_event.dart';
part 'language_state.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  LanguageBloc() : super(LanguageState(Locale('en', 'US')));

  @override
  Stream<LanguageState> mapEventToState(LanguageEvent event) async* {
    if (event is LanguageLoadStarted) {
      yield* _mapLanguageLoadStartedToState();
    } else if (event is LanguageSelected) {
      yield* _mapLanguageSelectedToState(event.languageCode);
    }
  }

  Stream<LanguageState> _mapLanguageLoadStartedToState() async* {
    final sharedPrefService = await SharedPreferencesLanguageService.instance;

    final defaultLanguageCode = sharedPrefService.languageCode;
    Locale locale;

    if (defaultLanguageCode == null) {
      locale = Locale('en', 'US');
      await sharedPrefService.setLanguage(locale.languageCode);
    } else {
      locale = Locale(defaultLanguageCode);
    }

    yield LanguageState(locale);
  }

  Stream<LanguageState> _mapLanguageSelectedToState(
      Language selectedLanguage) async* {
    final sharedPrefService = await SharedPreferencesLanguageService.instance;
    final defaultLanguageCode = sharedPrefService.languageCode;

    if (selectedLanguage == Language.EN && defaultLanguageCode != 'en') {
      yield* _loadLanguage(sharedPrefService, 'en', 'US');
    } else if (selectedLanguage == Language.DE && defaultLanguageCode != 'de') {
      yield* _loadLanguage(sharedPrefService, 'de', 'DE');
    } else if (selectedLanguage == Language.ES && defaultLanguageCode != 'es') {
      yield* _loadLanguage(sharedPrefService, 'es', 'ES');
    } else if (selectedLanguage == Language.FR && defaultLanguageCode != 'fr') {
      yield* _loadLanguage(sharedPrefService, 'fr', 'FR');
    } else if (selectedLanguage == Language.IT && defaultLanguageCode != 'it') {
      yield* _loadLanguage(sharedPrefService, 'it', 'IT');
    } else if (selectedLanguage == Language.NL && defaultLanguageCode != 'nl') {
      yield* _loadLanguage(sharedPrefService, 'nl', 'NL');
    } else if (selectedLanguage == Language.NO && defaultLanguageCode != 'no') {
      yield* _loadLanguage(sharedPrefService, 'no', 'NO');
    } else if (selectedLanguage == Language.PT && defaultLanguageCode != 'pt') {
      yield* _loadLanguage(sharedPrefService, 'pt', 'PT');
    } else if (selectedLanguage == Language.RU && defaultLanguageCode != 'ru') {
      yield* _loadLanguage(sharedPrefService, 'ru', 'RU');
    } else if (selectedLanguage == Language.ZH && defaultLanguageCode != 'zh') {
      yield* _loadLanguage(sharedPrefService, 'zh', 'CN');
    } else if (selectedLanguage == Language.SR && defaultLanguageCode != 'sr') {
      yield* _loadLanguage(sharedPrefService, 'sr', 'SR');
    }
  }

  Stream<LanguageState> _loadLanguage(
      SharedPreferencesLanguageService sharedPreferencesService,
      String languageCode,
      String countryCode) async* {
    final locale = Locale(languageCode, countryCode);
    await sharedPreferencesService.setLanguage(locale.languageCode);
    yield LanguageState(locale);
  }
}
