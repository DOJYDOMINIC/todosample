import 'package:shared_preferences/shared_preferences.dart';

class PrefsKey {
  static const token = 'token';
}

class UserPreferences {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Set token
  static Future<void> setToken(String value) async {
    await _prefs?.setString(PrefsKey.token, value);
  }

  // Get token
  static String get token => _prefs?.getString(PrefsKey.token) ?? '';

  // Remove token
  static Future<void> removeToken() async {
    await _prefs?.remove(PrefsKey.token);
  }

  // Clear all preferences (optional)
  static Future<void> clear() async {
    await _prefs?.clear();
  }
}


//shared_preferences