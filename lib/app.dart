import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'generated/app_localizations.dart';
import 'core/language/language_service.dart';
import 'features/role/select_role_screen.dart';
import 'services/update_service.dart';
import 'services/apk_update_service.dart';

class SkillLinkApp extends StatefulWidget {
  const SkillLinkApp({super.key});

  @override
  State<SkillLinkApp> createState() => _SkillLinkAppState();
}

class _SkillLinkAppState extends State<SkillLinkApp> {
  Locale _locale = const Locale('ur');

  @override
  void initState() {
    super.initState();
    _loadLanguage();

    // ÃƒÂ¢Ã…â€œÃ¢â‚¬Â¦ check update after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkForUpdate();
    });
  }

  Future<void> _loadLanguage() async {
    final code = await LanguageService.load();

    if (!mounted) return;

    setState(() {
      _locale = Locale(code);
    });
  }

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  // ===============================
  // ÃƒÂ°Ã…Â¸Ã…Â¡Ã¢â€šÂ¬ UPDATE SYSTEM (WITH PROGRESS)
  // ===============================
  Future<void> _checkForUpdate() async {
    final data = await UpdateService.checkUpdate();
    if (data == null) return;

    final latestVersion = data['version'];
    final message = data['message'];
    final apkUrl = data['apk_url'];

    final isUpdate = await UpdateService.isUpdateAvailable(latestVersion);

    if (!isUpdate || !mounted) return;

    showDialog(
      context: this.context,
      barrierDismissible: false,
      builder: (context) {
        double progress = 0;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Update Available ÃƒÂ°Ã…Â¸Ã…Â¡Ã¢â€šÂ¬"),

              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(message ?? "New update available"),
                  const SizedBox(height: 15),

                  LinearProgressIndicator(value: progress),

                  const SizedBox(height: 10),

                  Text("${(progress * 100).toStringAsFixed(0)}%"),
                ],
              ),

              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Later"),
                ),

                ElevatedButton(
                  onPressed: () async {
                    await ApkUpdateService.downloadAndInstall(
                      apkUrl,
                      (p) {
                        setState(() {
                          progress = p;
                        });
                      },
                    );
                  },
                  child: const Text("Download & Install"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // ÃƒÂ°Ã…Â¸Ã…â€™Ã‚Â ACTIVE LANGUAGE
      locale: _locale,

      // ÃƒÂ°Ã…Â¸Ã…â€™Ã‚Â SUPPORTED LANGUAGES
      supportedLocales: const [
        Locale('ur'),
        Locale('en'),
        Locale('ar'),
        Locale('nl'),
      ],

      // ÃƒÂ°Ã…Â¸Ã…â€™Ã‚Â LOCALIZATION SYSTEM
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // ÃƒÂ°Ã…Â¸Ã…â€™Ã‚Â FALLBACK LOGIC
      localeResolutionCallback: (locale, supportedLocales) {
        if (locale == null) return const Locale('ur');

        for (final supported in supportedLocales) {
          if (supported.languageCode == locale.languageCode) {
            return supported;
          }
        }
        return const Locale('ur');
      },

      // ÃƒÂ°Ã…Â¸Ã…Â¡Ã¢â€šÂ¬ FIRST SCREEN
      home: SelectRoleScreen(
        onLocaleChange: setLocale,
      ),
    );
  }
}

