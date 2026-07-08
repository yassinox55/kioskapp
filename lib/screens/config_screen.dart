import 'package:flutter/material.dart';
import '../services/config_service.dart';
import 'kiosk_screen.dart';

/// Écran où on définit l'URL du site et le code PIN de sortie
class ConfigScreen extends StatefulWidget {
  const ConfigScreen({super.key});

  @override
  State<ConfigScreen> createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  final _urlController = TextEditingController();
  final _pinController = TextEditingController();
  String? _errorMessage;

  void _saveAndStart() async {
    final url = _urlController.text.trim();
    final pin = _pinController.text.trim();

    if (url.isEmpty || !url.startsWith('http')) {
      setState(() => _errorMessage = "Entrez une URL valide (ex: https://...)");
      return;
    }
    if (pin.length < 4) {
      setState(() => _errorMessage = "Le code PIN doit faire au moins 4 chiffres");
      return;
    }

    await ConfigService.saveConfig(url: url, pin: pin);

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const KioskScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Configuration du kiosque")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Configurez l'URL à afficher et le code PIN pour sortir du mode kiosque.",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _urlController,
              decoration: const InputDecoration(
                labelText: "URL du site",
                hintText: "https://exemple.com",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _pinController,
              decoration: const InputDecoration(
                labelText: "Code PIN (4 chiffres minimum)",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              obscureText: true,
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 12),
              Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
            ],
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveAndStart,
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 14),
                child: Text("Démarrer le mode kiosque"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}