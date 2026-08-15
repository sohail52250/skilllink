import 'dart:io';

import 'package:dio/dio.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ApkUpdateService {
  static final Dio _dio = Dio();

  static Future<void> downloadAndInstall(
    String url,
    Function(double progress)? onProgress,
  ) async {
    try {
      // Request permissions
      await _requestPermissions();

      // Download folder
      Directory dir = Directory("/storage/emulated/0/Download");

      if (!await dir.exists()) {
        dir =
            await getExternalStorageDirectory() ??
            await getTemporaryDirectory();
      }

      final filePath = "${dir.path}/skilllink_update.apk";

      // Remove old APK if exists
      final oldFile = File(filePath);
      if (await oldFile.exists()) {
        await oldFile.delete();
      }

      // Download APK
      await _dio.download(
        url,
        filePath,
        deleteOnError: true,
        onReceiveProgress: (received, total) {
          if (total > 0) {
            final progress = received / total;
            onProgress?.call(progress);
          }
        },
      );

      final apkFile = File(filePath);

      if (!await apkFile.exists()) {
        throw Exception("APK file not found after download.");
      }

      final fileSize = await apkFile.length();

      print("APK downloaded successfully");
      print("Path: $filePath");
      print("Size: $fileSize bytes");

      // Very small file usually means Google Drive returned HTML
      if (fileSize < 1000000) {
        throw Exception(
          "Downloaded file is too small. Google Drive may have returned an HTML page instead of the APK.",
        );
      }

      // Open Android installer
      final result = await OpenFile.open(filePath);

      print("OpenFile result: ${result.type}");
      print("Message: ${result.message}");
    } catch (e) {
      print("APK Update Error: $e");
      rethrow;
    }
  }

  static Future<void> _requestPermissions() async {
    await Permission.storage.request();

    if (await Permission.requestInstallPackages.isDenied) {
      await Permission.requestInstallPackages.request();
    }
  }
}