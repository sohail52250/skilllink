import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

class UpdateService {
  static const String apkUrl =
      "https://drive.google.com/uc?export=download&id=1Tig58zyapj_U2CiVCGXzGm388VhMG9NF";

  static Future<Map<String, dynamic>?> checkUpdate() async {
    try {
      final res = await http.get(
        Uri.parse('https://skilllink-56764.web.app/version.json'),
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);

        data['apk_url'] = apkUrl;

        return data;
      }
    } catch (e) {
      print(e);
    }

    return null;
  }

  static Future<bool> isUpdateAvailable(String latestVersion) async {
    final info = await PackageInfo.fromPlatform();
    return latestVersion != info.version;
  }
}