import 'package:shared_preferences/shared_preferences.dart';

class LanguageService {
  static Future<void> save(String code) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      'language',
      code,
    );
  }

  static Future<String> load() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString('language') ?? 'ur';
  }
}