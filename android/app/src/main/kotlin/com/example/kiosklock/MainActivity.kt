package com.example.kiosklock

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "kiosklock/lock"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "startKiosk" -> {
                    startLockTask()
                    result.success(null)
                }
                "stopKiosk" -> {
                    stopLockTask()
                    result.success(null)
                }
                "getInstalledApps" -> {
                    val pm = packageManager
                    val apps = mutableListOf<Map<String, String>>()
                    val intent = android.content.Intent(android.content.Intent.ACTION_MAIN, null)
                    intent.addCategory(android.content.Intent.CATEGORY_LAUNCHER)
                    val resolvedApps = pm.queryIntentActivities(intent, 0)
                    for (resolveInfo in resolvedApps) {
                        val appName = resolveInfo.loadLabel(pm).toString()
                        val packageName = resolveInfo.activityInfo.packageName
                        apps.add(mapOf("name" to appName, "package" to packageName))
                    }
                    result.success(apps)
                }
                "launchApp" -> {
                    val packageName = call.argument<String>("package")
                    if (packageName != null) {
                        val launchIntent = packageManager.getLaunchIntentForPackage(packageName)
                        if (launchIntent != null) {
                            startActivity(launchIntent)
                            result.success(true)
                        } else {
                            result.error("NOT_FOUND", "Impossible de lancer l'application", null)
                        }
                    } else {
                        result.error("INVALID_ARG", "Nom de package manquant", null)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }
}