import 'package:shared_preferences/shared_preferences.dart';

/// Gère la sauvegarde et la lecture de la configuration (URL + PIN)
class ConfigService {
  static const _urlKey = 'kiosk_url';
  static const _pinKey = 'kiosk_pin';

  static Future<String?> getUrl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_urlKey);
  }

  static Future<String?> getPin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_pinKey);
  }

  static Future<void> saveConfig({required String url, required String pin}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_urlKey, url);
    await prefs.setString(_pinKey, pin);
  }

  static Future<bool> isConfigured() async {
    final url = await getUrl();
    return url != null && url.isNotEmpty;
  }
}