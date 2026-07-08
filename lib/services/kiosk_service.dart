
import 'package:flutter/services.dart';
import 'app_logger.dart';

/// Gère la communication avec le code natif Android pour le mode kiosque
class KioskService {
  static const _platform = MethodChannel('kiosklock/lock');

  static Future<void> startKiosk() async {
    try {
      await _platform.invokeMethod('startKiosk');
      AppLogger.instance.log("Mode kiosque activé");
    } on PlatformException catch (e) {
      AppLogger.instance.log("Erreur activation kiosque: ${e.message}");
    }
  }

  static Future<void> stopKiosk() async {
    try {
      await _platform.invokeMethod('stopKiosk');
      AppLogger.instance.log("Mode kiosque désactivé");
    } on PlatformException catch (e) {
      AppLogger.instance.log("Erreur désactivation kiosque: ${e.message}");
    }
  }
}