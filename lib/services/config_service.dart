import 'package:shared_preferences/shared_preferences.dart';

class ConfigService {
  static const _userUsernameKey = 'user_username';
  static const _userPasswordKey = 'user_password';
  static const _adminUsernameKey = 'admin_username';
  static const _adminPasswordKey = 'admin_password';
  static const _allowedAppsKey = 'allowed_apps';

  static Future<String?> getUserUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userUsernameKey);
  }

  static Future<String?> getUserPassword() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userPasswordKey);
  }

  static Future<String?> getAdminUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_adminUsernameKey);
  }

  static Future<String?> getAdminPassword() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_adminPasswordKey);
  }

  static Future<void> saveConfig({
    required String userUsername,
    required String userPassword,
    required String adminUsername,
    required String adminPassword,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userUsernameKey, userUsername);
    await prefs.setString(_userPasswordKey, userPassword);
    await prefs.setString(_adminUsernameKey, adminUsername);
    await prefs.setString(_adminPasswordKey, adminPassword);
  }

  static Future<bool> isConfigured() async {
    final username = await getUserUsername();
    return username != null && username.isNotEmpty;
  }

  static Future<List<String>> getAllowedApps() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_allowedAppsKey) ?? [];
  }

  static Future<void> saveAllowedApps(List<String> packageNames) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_allowedAppsKey, packageNames);
  }
}