import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';

import 'app.dart';
import 'firebase_options.dart';
import 'services/update_service.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const ProviderScope(child: SkillLinkApp()));
}

/// ✅ Call this after app starts (inside first screen)
void checkForUpdate() async {
  final context = navigatorKey.currentContext;
  if (context == null) return;

  final data = await UpdateService.checkUpdate();
  if (data == null) return;

  final latestVersion = data['version'];
  final message = data['message'];
  final apkUrl = data['apk_url'];

  final isUpdate = await UpdateService.isUpdateAvailable(latestVersion);

  if (isUpdate && context.mounted) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text("Update Available 🚀"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Later"),
          ),
          ElevatedButton(
            onPressed: () async {
              final url = Uri.parse(apkUrl);
              await launchUrl(
                url,
                mode: LaunchMode.externalApplication,
              );
            },
            child: const Text("Download & Install"),
          ),
        ],
      ),
    );
  }
}