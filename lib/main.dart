import 'dart:convert';


import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_hyuabot_v2/Config/LocalizationDelegate.dart';
import 'package:flutter_app_hyuabot_v2/Config/Theme.dart';
import 'package:flutter_app_hyuabot_v2/Page/HomePage.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:get/get.dart';

import 'package:flutter_app_hyuabot_v2/Config/GlobalVars.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  savedThemeMode = await AdaptiveTheme.getThemeMode();
  prefManager = await SharedPreferences.getInstance();
  Firebase.initializeApp();
  runApp(Phoenix(child: MyApp()));
}


class MyApp extends StatelessWidget {
  final FirebaseAnalytics analytics = FirebaseAnalytics();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
        light: lightTheme,
        dark: darkTheme,
        initial: savedThemeMode ?? AdaptiveThemeMode.system,
        builder: (theme, darkTheme) => GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: theme,
          home: HomePage(),
          navigatorObservers: [FirebaseAnalyticsObserver(analytics: analytics)],
          supportedLocales: [const Locale('ko', 'KR'), const Locale('en', 'US'), const Locale('zh')],
          localizationsDelegates: [const TranslationsDelegate(), GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate],
          localeResolutionCallback: (Locale locale, Iterable<Locale> supportedLocales){
            var localeCode = prefManager.getString("localeCode");
            switch(localeCode){
              case 'ko_KR':
                return const Locale('ko', 'KR');
                break;
              case 'en_US':
                return const Locale('en', 'US');
                break;
              case 'zh':
                return const Locale('zh');
                break;
              default:
                return supportedLocales.first;
            }
          },
      )
    );
  }
}
