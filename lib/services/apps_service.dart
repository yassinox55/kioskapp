import 'package:flutter/services.dart';

class AppInfo {
  final String name;
  final String packageName;

  AppInfo({required this.name, required this.packageName});
}

/// Communique avec Android pour lister et lancer des applications
class AppsService {
  static const _platform = MethodChannel('kiosklock/lock');

  static Future<List<AppInfo>> getInstalledApps() async {
    final result = await _platform.invokeMethod('getInstalledApps');
    final list = List<Map<dynamic, dynamic>>.from(result);
    return list
        .map((e) => AppInfo(name: e['name'] as String, packageName: e['package'] as String))
        .toList()
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  }

  static Future<void> launchApp(String packageName) async {
    await _platform.invokeMethod('launchApp', {'package': packageName});
  }
}