import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'services/update_service.dart';

class UpdateChecker {
  static Future<void> checkForUpdate(BuildContext context) async {
    final data = await UpdateService.checkUpdate();

    if (data == null) return;

    final latestVersion = data['version'];
    final message = data['message'];
    final apkUrl = data['apk_url'];

    final isUpdate =
        await UpdateService.isUpdateAvailable(latestVersion);

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
              child: const Text("Update Now"),
            ),
          ],
        ),
      );
    }
  }
}