import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  static const _key = 'user_session';

  static Future<void> save(String phoneOrEmail) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, phoneOrEmail);
  }

  static Future<String?> get() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_key);
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
