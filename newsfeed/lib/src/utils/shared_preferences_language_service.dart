import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefKeys {
  SharedPrefKeys._();
  static const String languageCode = 'languageCode';
}

class SharedPreferencesLanguageService {
  static SharedPreferencesLanguageService _instance;
  static SharedPreferences _preferences;

  SharedPreferencesLanguageService._internal();

  static Future<SharedPreferencesLanguageService> get instance async {
    if (_instance == null) {
      _instance = SharedPreferencesLanguageService._internal();
    }

    if (_preferences == null) {
      _preferences = await SharedPreferences.getInstance();
    }

    return _instance;
  }

  Future<void> setLanguage(String langCode) async =>
      await _preferences.setString(SharedPrefKeys.languageCode, langCode);

  String get languageCode =>
      _preferences.getString(SharedPrefKeys.languageCode);
}
