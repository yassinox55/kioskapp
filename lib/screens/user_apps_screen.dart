import 'package:flutter/material.dart';
import '../services/apps_service.dart';
import '../services/config_service.dart';
import '../services/kiosk_service.dart';
import 'login_screen.dart';

class UserAppsScreen extends StatefulWidget {
  const UserAppsScreen({super.key});

  @override
  State<UserAppsScreen> createState() => _UserAppsScreenState();
}

class _UserAppsScreenState extends State<UserAppsScreen> {
  List<AppInfo> _allowedApps = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      KioskService.startKiosk();
    });
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final allApps = await AppsService.getInstalledApps();
    final allowedPackages = await ConfigService.getAllowedApps();
    setState(() {
      _allowedApps = allApps.where((a) => allowedPackages.contains(a.packageName)).toList();
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mes applications"),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _load, tooltip: "Rafraîchir"),
          IconButton(
            icon: const Icon(Icons.admin_panel_settings_outlined),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            tooltip: "Connexion Admin",
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _allowedApps.isEmpty
              ? const Center(child: Text("Aucune application autorisée pour l'instant"))
              : ListView.builder(
                  itemCount: _allowedApps.length,
                  itemBuilder: (context, index) {
                    final app = _allowedApps[index];
                    return ListTile(
                      leading: const Icon(Icons.apps),
                      title: Text(app.name),
                      onTap: () => AppsService.launchApp(app.packageName),
                    );
                  },
                ),
    );
  }
}