import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:url_launcher/url_launcher.dart';

import 'web_reload_stub.dart'
    if (dart.library.html) 'web_reload_html.dart';

class SmartUpdateManager {
  SmartUpdateManager._();

  static final SmartUpdateManager instance = SmartUpdateManager._();

  String? latestVersion;
  String? apkUrl;
  String? webVersion;

  bool forceUpdate = false;
  bool showWebUpdate = false;

  Future<Version?> _getCurrentVersion() async {
    final info = await PackageInfo.fromPlatform();

    try {
      return Version.parse(info.version);
    } catch (_) {
      return null;
    }
  }

  Future<void> checkForUpdate({
    required BuildContext context,
    VoidCallback? onWebUpdateAvailable,
    VoidCallback? onForceUpdate,
  }) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('app_config')
          .doc('version')
          .get();

      if (!doc.exists || doc.data() == null) {
        return;
      }

      final data = doc.data()!;

      latestVersion = data['latest_version']?.toString();
      webVersion = data['web_version']?.toString();

      final rawUrl = data['apk_url']?.toString();

      if (rawUrl != null && rawUrl.startsWith('http')) {
        apkUrl = rawUrl;
      }

      final current = await _getCurrentVersion();
      final latest = _parse(latestVersion);

      if (current == null || latest == null) {
        return;
      }

      if (!kIsWeb && latest > current) {
        forceUpdate = true;
        onForceUpdate?.call();
      }

      if (kIsWeb) {
        final webLatest = _parse(webVersion);

        if (webLatest != null && webLatest > current) {
          showWebUpdate = true;
          onWebUpdateAvailable?.call();
        }
      }
    } catch (e) {
      debugPrint('SmartUpdateManager error: $e');
    }
  }

  Version? _parse(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }

    try {
      return Version.parse(value);
    } catch (_) {
      return null;
    }
  }

  Future<void> openAPK() async {
    final url = apkUrl;

    if (url == null || url.isEmpty) {
      return;
    }

    final uri = Uri.tryParse(url);

    if (uri == null) {
      return;
    }

    try {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      debugPrint('APK open failed: $e');
    }
  }

  void reloadWeb() {
    reloadWebPage();
  }
}
