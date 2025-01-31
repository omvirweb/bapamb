import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static final PreferencesService _instance = PreferencesService._internal();

  factory PreferencesService() {
    return _instance;
  }

  PreferencesService._internal();

  Future<SharedPreferences> _getPreferences() async {
    return await SharedPreferences.getInstance();
  }

  // Save a boolean value
  Future<void> saveBool(String key, bool value) async {
    final prefs = await _getPreferences();
    await prefs.setBool(key, value);
  }

  // Get a boolean value
  Future<bool> getBool(String key, bool defValue) async {
    final prefs = await _getPreferences();
    return prefs.getBool(key) ?? defValue;
  }

  // Save a String value
  Future<void> saveString(String key, String value) async {
    final prefs = await _getPreferences();
    await prefs.setString(key, value);
  }

  // Get a String value
  Future<String?> getString(String key, String defValue) async {
    final prefs = await _getPreferences();
    return prefs.getString(key) ?? defValue;
  }

  // Clear all preferences
  Future<void> clear() async {
    final prefs = await _getPreferences();
    await prefs.clear();
  }
}
