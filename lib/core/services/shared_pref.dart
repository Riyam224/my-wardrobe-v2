import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static late final SharedPreferences _instance;

  // Init must be awaited before using any other method
  static Future<void> init() async {
    _instance = await SharedPreferences.getInstance();
  }

  static Future<bool> setBool(String key, bool value) async {
    return await _instance.setBool(key, value);
  }

  static bool getBool(String key) {
    return _instance.getBool(key) ?? false;
  }
}
