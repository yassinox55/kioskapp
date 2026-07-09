import 'package:flutter/material.dart';
import 'config_screen.dart';
import '../services/kiosk_service.dart';
import 'admin_apps_screen.dart';

/// Interface Admin : accessible uniquement avec le PIN
class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Espace Admin")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Gestion du kiosque",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            _AdminTile(
              icon: Icons.link_rounded,
              title: "Changer l'URL / le PIN",
              subtitle: "Reconfigurer le site affiché",
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ConfigScreen(isReconfiguring: true),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            _AdminTile(
              icon: Icons.apps,
              title: "Gérer les applications",
              subtitle: "Choisir les apps visibles pour l'utilisateur",
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const AdminAppsScreen()),
                );
              },
            ),
            const SizedBox(height: 12),
            _AdminTile(
              icon: Icons.exit_to_app_rounded,
              title: "Quitter le mode kiosque",
              subtitle: "Débloquer l'appareil",
              onTap: () async {
                await KioskService.stopKiosk();
                if (context.mounted) Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _AdminTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _AdminTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}