import 'package:flutter/material.dart';
import '../services/config_service.dart';
import 'login_screen.dart';

class ConfigScreen extends StatefulWidget {
  final bool isReconfiguring;
  const ConfigScreen({super.key, this.isReconfiguring = false});

  @override
  State<ConfigScreen> createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  final _userUsernameController = TextEditingController();
  final _userPasswordController = TextEditingController();
  final _adminUsernameController = TextEditingController();
  final _adminPasswordController = TextEditingController();
  String? _errorMessage;

  void _saveAndStart() async {
    final userUsername = _userUsernameController.text.trim();
    final userPassword = _userPasswordController.text.trim();
    final adminUsername = _adminUsernameController.text.trim();
    final adminPassword = _adminPasswordController.text.trim();

    if (userUsername.isEmpty || userPassword.isEmpty) {
      setState(() => _errorMessage = "Identifiant et mot de passe utilisateur requis");
      return;
    }
    if (adminUsername.isEmpty || adminPassword.isEmpty) {
      setState(() => _errorMessage = "Identifiant et mot de passe admin requis");
      return;
    }

    await ConfigService.saveConfig(
      userUsername: userUsername,
      userPassword: userPassword,
      adminUsername: adminUsername,
      adminPassword: adminPassword,
    );

    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  Widget _sectionTitle(String text) => Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 8),
        child: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.grey),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0D47A1), Color(0xFF1976D2), Color(0xFFE3F2FD)],
            stops: [0.0, 0.35, 1.0],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 20, offset: const Offset(0, 8)),
                      ],
                    ),
                    child: const Icon(Icons.tablet_mac_rounded, size: 42, color: Color(0xFF1976D2)),
                  ),
                  const SizedBox(height: 12),
                  const Text("kiosk", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 24, offset: const Offset(0, 10)),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _sectionTitle("IDENTIFIANTS UTILISATEUR"),
                        TextField(
                          controller: _userUsernameController,
                          decoration: const InputDecoration(
                            labelText: "Identifiant utilisateur",
                            prefixIcon: Icon(Icons.person_outline),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _userPasswordController,
                          decoration: const InputDecoration(
                            labelText: "Mot de passe utilisateur",
                            prefixIcon: Icon(Icons.lock_outline),
                            border: OutlineInputBorder(),
                          ),
                          obscureText: true,
                        ),
                        _sectionTitle("IDENTIFIANTS ADMIN"),
                        TextField(
                          controller: _adminUsernameController,
                          decoration: const InputDecoration(
                            labelText: "Identifiant admin",
                            prefixIcon: Icon(Icons.admin_panel_settings_outlined),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _adminPasswordController,
                          decoration: const InputDecoration(
                            labelText: "Mot de passe admin",
                            prefixIcon: Icon(Icons.lock_outline),
                            border: OutlineInputBorder(),
                          ),
                          obscureText: true,
                        ),
                        if (_errorMessage != null) ...[
                          const SizedBox(height: 12),
                          Text(_errorMessage!, style: const TextStyle(color: Colors.red, fontSize: 13)),
                        ],
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _saveAndStart,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1976D2),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Text(
                              "Enregistrer et démarrer",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}