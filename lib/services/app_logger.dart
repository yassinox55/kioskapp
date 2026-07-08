import 'package:flutter/foundation.dart';

/// Gère tous les logs de l'application (démarrage, navigation, réseau...)
class AppLogger extends ChangeNotifier {
  static final AppLogger instance = AppLogger._internal();
  AppLogger._internal();

  final List<String> logs = [];

  void log(String message) {
    final timestamp = DateTime.now().toIso8601String().substring(11, 19); // HH:mm:ss
    final entry = "[$timestamp] $message";
    logs.add(entry);
    debugPrint(entry);
    notifyListeners();
  }

  void clear() {
    logs.clear();
    notifyListeners();
  }
}