import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../services/app_logger.dart';
import '../services/kiosk_service.dart';
import 'logs_screen.dart';

/// Écran principal : affiche le site web en plein écran et active le mode kiosque
class KioskScreen extends StatefulWidget {
  const KioskScreen({super.key});

  @override
  State<KioskScreen> createState() => _KioskScreenState();
}

class _KioskScreenState extends State<KioskScreen> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    AppLogger.instance.log("App démarrée");

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'AppNetworkLogger',
        onMessageReceived: (JavaScriptMessage message) {
          AppLogger.instance.log("[RESEAU] ${message.message}");
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            AppLogger.instance.log("Chargement de la page: $url");
          },
          onPageFinished: (String url) {
            AppLogger.instance.log("Page chargée: $url");
            _injectNetworkLogger();
          },
          onNavigationRequest: (NavigationRequest request) {
            AppLogger.instance.log("Navigation demandée (GET): ${request.url}");
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://flutter.dev'));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      KioskService.startKiosk();
    });
  }

  Future<void> _injectNetworkLogger() async {
    const jsCode = """
      (function() {
        if (window.__kiosklockLoggerInstalled) return;
        window.__kiosklockLoggerInstalled = true;

        const originalFetch = window.fetch;
        window.fetch = function(...args) {
          const url = args[0];
          const method = (args[1] && args[1].method) || 'GET';
          AppNetworkLogger.postMessage('FETCH ' + method + ' ' + url);
          return originalFetch.apply(this, args);
        };

        const originalOpen = XMLHttpRequest.prototype.open;
        XMLHttpRequest.prototype.open = function(method, url) {
          AppNetworkLogger.postMessage('XHR ' + method + ' ' + url);
          return originalOpen.apply(this, arguments);
        };
      })();
    """;
    await controller.runJavaScript(jsCode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            WebViewWidget(controller: controller),
            Positioned(
              top: 10,
              right: 10,
              child: FloatingActionButton.small(
                heroTag: "logsButton",
                backgroundColor: Colors.black54,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const LogsScreen()),
                  );
                },
                child: const Icon(Icons.build, color: Colors.white, size: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}