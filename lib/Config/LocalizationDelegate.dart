import 'dart:async';

import 'package:flutter/material.dart';
import 'Localization.dart';

class TranslationsDelegate extends LocalizationsDelegate<TranslationManager> {
  const TranslationsDelegate();

  @override
  bool isSupported(Locale locale) => ['ko', 'en', 'zh'].contains(locale.languageCode);

  @override
  Future<TranslationManager> load(Locale locale) async {
    TranslationManager localizations = new TranslationManager(locale);
    await localizations.load();

    print("Load ${locale.languageCode}");

    return localizations;
  }

  @override
  bool shouldReload(TranslationsDelegate old) => false;
}