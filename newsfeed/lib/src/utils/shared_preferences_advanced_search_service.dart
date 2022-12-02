import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefKeys {
  SharedPrefKeys._();
  static const String dateFrom = 'dateFrom';
  static const String dateTo = 'dateTo';
  static const String country = 'country';
  static const String source = 'source';
  static const String paging = 'paging';
  static const String sorting = 'sorting';
}

class SharedPreferencesAdvancedSearchService {
  static SharedPreferencesAdvancedSearchService _instance;
  static SharedPreferences _preferences;

  SharedPreferencesAdvancedSearchService._internal();

  static Future<SharedPreferencesAdvancedSearchService> get instance async {
    if (_instance == null) {
      _instance = SharedPreferencesAdvancedSearchService._internal();
    }

    if (_preferences == null) {
      _preferences = await SharedPreferences.getInstance();
    }

    return _instance;
  }

  Future<void> setDate(String dateFrom, String dateTo) async {
    await _preferences.setString(SharedPrefKeys.dateFrom, dateFrom);
    await _preferences.setString(SharedPrefKeys.dateTo, dateTo);
  }

  Future<void> setCountry(String country) async =>
      await _preferences.setString(SharedPrefKeys.country, country);

  Future<void> setSource(String source) async =>
      await _preferences.setString(SharedPrefKeys.source, source);

  Future<void> setPaging(String paging) async =>
      await _preferences.setString(SharedPrefKeys.paging, paging);

  String get dateFrom => _preferences.getString(SharedPrefKeys.dateFrom);

  String get dateTo => _preferences.getString(SharedPrefKeys.dateTo);

  String get country => _preferences.getString(SharedPrefKeys.country);

  String get source => _preferences.getString(SharedPrefKeys.source);

  String get paging => _preferences.getString(SharedPrefKeys.paging);

  String get sorting => _preferences.getString(SharedPrefKeys.sorting);
}
