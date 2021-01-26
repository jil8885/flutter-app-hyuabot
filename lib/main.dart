import 'package:flutter/material.dart';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_app_hyuabot_v2/Config/GlobalVars.dart';
import 'package:flutter_app_hyuabot_v2/Config/TranslationManager.dart';
import 'package:flutter_app_hyuabot_v2/Page/SplashScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Firebase.initializeApp();
    analytics = FirebaseAnalytics();

    Locale _locale;
    SharedPreferences.getInstance().then((value){
      prefManager = value;
    }).whenComplete((){
      switch(prefManager.getString("localeCode")){
        case 'ko_KR':
          _locale = Locale("ko", "KR");
          break;
        case 'en_US':
          _locale = Locale("en", "US");
          break;
        case 'zh':
          _locale = Locale('zh');
          break;
        default:
          _locale = Get.deviceLocale;
          prefManager.setString("localeCode", Get.deviceLocale.toLanguageTag());
          break;
      }
    });
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      translations: TranslationManager(),
      locale: _locale,
      fallbackLocale: Locale('ko', 'KR'),
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
