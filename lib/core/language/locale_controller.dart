import 'package:flutter/material.dart';

class LocaleController {
  static final ValueNotifier<Locale> locale =
      ValueNotifier(const Locale('en'));

  static void change(Locale newLocale) {
    locale.value = newLocale;
  }
}