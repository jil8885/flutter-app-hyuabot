import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TranslationManager {
  TranslationManager(this.locale);

  final Locale locale;

  static TranslationManager of(BuildContext context) {
    return Localizations.of<TranslationManager>(context, TranslationManager);
  }

  Map<String, String> _sentences;

  Future<bool> load() async {
    String data = await rootBundle.loadString('assets/locale/${this.locale.languageCode}.json');
    Map<String, dynamic> _result = json.decode(data);

    this._sentences = new Map();
    _result.forEach((String key, dynamic value) {
      this._sentences[key] = value.toString();
    });

    return true;
  }

  String trans(String key) {
    return this._sentences[key];
  }
}