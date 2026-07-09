import 'package:flutter/material.dart';
import '../services/apps_service.dart';
import '../services/config_service.dart';

/// Écran Admin : coche les applications autorisées pour l'utilisateur
class AdminAppsScreen extends StatefulWidget {
  const AdminAppsScreen({super.key});

  @override
  State<AdminAppsScreen> createState() => _AdminAppsScreenState();
}

class _AdminAppsScreenState extends State<AdminAppsScreen> {
  List<AppInfo> _allApps = [];
  Set<String> _selected = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final apps = await AppsService.getInstalledApps();
    final allowed = await ConfigService.getAllowedApps();
    setState(() {
      _allApps = apps;
      _selected = allowed.toSet();
      _loading = false;
    });
  }

  Future<void> _save() async {
    await ConfigService.saveAllowedApps(_selected.toList());
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Applications autorisées enregistrées")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Applications autorisées"),
        actions: [
          IconButton(icon: const Icon(Icons.save), onPressed: _save, tooltip: "Enregistrer"),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _allApps.length,
              itemBuilder: (context, index) {
                final app = _allApps[index];
                final isChecked = _selected.contains(app.packageName);
                return CheckboxListTile(
                  title: Text(app.name),
                  subtitle: Text(app.packageName, style: const TextStyle(fontSize: 11)),
                  value: isChecked,
                  onChanged: (checked) {
                    setState(() {
                      if (checked == true) {
                        _selected.add(app.packageName);
                      } else {
                        _selected.remove(app.packageName);
                      }
                    });
                  },
                );
              },
            ),
    );
  }
}