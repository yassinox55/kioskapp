import 'package:flutter/material.dart';
import '../services/app_logger.dart';

/// Écran qui affiche l'historique des logs de l'application
class LogsScreen extends StatefulWidget {
  const LogsScreen({super.key});

  @override
  State<LogsScreen> createState() => _LogsScreenState();
}

class _LogsScreenState extends State<LogsScreen> {
  @override
  void initState() {
    super.initState();
    AppLogger.instance.addListener(_onLogsChanged);
  }

  @override
  void dispose() {
    AppLogger.instance.removeListener(_onLogsChanged);
    super.dispose();
  }

  void _onLogsChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final logs = AppLogger.instance.logs;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Logs de l'application"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => AppLogger.instance.clear(),
            tooltip: "Effacer les logs",
          ),
        ],
      ),
      body: logs.isEmpty
          ? const Center(child: Text("Aucun log pour l'instant"))
          : ListView.builder(
              reverse: true,
              itemCount: logs.length,
              itemBuilder: (context, index) {
                final entry = logs[logs.length - 1 - index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: Text(
                    entry,
                    style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                  ),
                );
              },
            ),
    );
  }
}