import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesTopicSelectService {
  static SharedPreferencesTopicSelectService _instance;
  static SharedPreferences _preferences;

  SharedPreferencesTopicSelectService._internal();

  static Future<SharedPreferencesTopicSelectService> get instance async {
    if (_instance == null) {
      _instance = SharedPreferencesTopicSelectService._internal();
    }

    if (_preferences == null) {
      _preferences = await SharedPreferences.getInstance();
    }

    return _instance;
  }

  bool isFirstTime() {
    var isFirstTime = _preferences.getBool('first_time');

    if (isFirstTime != null && !isFirstTime) {
      return false;
    } else {
      return true;
    }
  }

  Future<void> setValue() async {
    await _preferences.setBool('first_time', false);
  }
}
