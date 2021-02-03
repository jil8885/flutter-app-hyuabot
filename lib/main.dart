import 'package:flutter/material.dart';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_app_hyuabot_v2/Config/Theme.dart';
import 'package:get/get.dart';

import 'package:flutter_app_hyuabot_v2/Config/GlobalVars.dart';
import 'package:flutter_app_hyuabot_v2/Config/TranslationManager.dart';
import 'package:flutter_app_hyuabot_v2/Page/SplashScreen.dart';
import 'package:get_storage/get_storage.dart';

void main() async{
  await GetStorage.init();
  await Firebase.initializeApp();
  analytics = FirebaseAnalytics();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Locale _locale = Locale("ko", "KR");
    prefManager.writeIfNull("localeCode", 'ko_KR');
    switch(prefManager.read("localeCode")) {
      case 'ko_KR':
        _locale = Locale("ko", "KR");
        break;
      case 'en_US':
        _locale = Locale("en", "US");
        break;
      case 'zh':
        _locale = Locale('zh');
        break;
    }
    prefManager.writeIfNull("theme", "auto");
    ThemeMode _mode;
    switch(prefManager.read("theme")) {
      case 'auto':
        _mode = ThemeMode.system;
        break;
      case 'light':
        _mode = ThemeMode.light;
        break;
      case 'dark':
        _mode = ThemeMode.dark;
        break;
    }

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      translations: TranslationManager(),
      locale: _locale,
      fallbackLocale: Locale('ko', 'KR'),
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: _mode,
      home: SplashScreen(),
      builder: (context, child) {
        return MediaQuery(
          child: child,
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        );
      },
      navigatorObservers: [FirebaseAnalyticsObserver(analytics: analytics)],
    );
  }
}
