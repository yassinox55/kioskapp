import 'package:flutter/material.dart';
import 'screens/kiosk_screen.dart';
import 'screens/config_screen.dart';
import 'services/config_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const StartupScreen(),
    );
  }
}

/// Décide si on affiche la config ou directement le kiosque
class StartupScreen extends StatelessWidget {
  const StartupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: ConfigService.isConfigured(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        return snapshot.data! ? const KioskScreen() : const ConfigScreen();
      },
    );
  }
}