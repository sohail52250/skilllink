import 'package:flutter/material.dart';

class AppStrings {
  static const Map<String, Map<String, String>> _values = {
    'en': {
      'welcome': 'Welcome to SkillLink Marketplace',
      'desc': 'Find jobs, hire workers, and grow your skills',
      'search': 'Search jobs or workers',
    },
    'ur': {
      'welcome': 'اسکل لنک مارکیٹ پلیس میں خوش آمدید',
      'desc': 'نوکریاں تلاش کریں اور ورکرز رکھیں',
      'search': 'نوکریاں یا ورکرز تلاش کریں',
    },
    'ar': {
      'welcome': 'مرحبًا بك في سكيل لنك',
      'desc': 'ابحث عن وظائف أو عمال',
      'search': 'ابحث عن وظائف أو عمال',
    },
    'nl': {
      'welcome': 'Welkom bij SkillLink',
      'desc': 'Vind banen en werknemers',
      'search': 'Zoek banen of werknemers',
    },
  };

  static String get(BuildContext context, String key) {
    final lang = Localizations.localeOf(context).languageCode;
    return _values[lang]?[key] ?? _values['en']![key]!;
  }
}