import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_app_hyuabot_v2/Config/GlobalVars.dart';
import 'package:flutter_app_hyuabot_v2/Config/Theme.dart';
import 'package:flutter_app_hyuabot_v2/Page/HomePage.dart';
import 'package:flutter_app_hyuabot_v2/Page/SplashScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  prefManager = await SharedPreferences.getInstance();
  savedThemeMode = await AdaptiveTheme.getThemeMode();
  analytics = FirebaseAnalytics();
  runApp(EasyLocalization(
      child: MyApp(),
      supportedLocales: [Locale('ko', 'KR'), Locale('en', 'US'), Locale('zh')],
      fallbackLocale: Locale('ko', 'KR'),
      path: 'assets/translations'
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: lightTheme,
      dark: darkTheme,
      initial: savedThemeMode ?? AdaptiveThemeMode.system,
      builder: (lightTheme, darkTheme){
        return MaterialApp(
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          theme: lightTheme,
          darkTheme: darkTheme,
          debugShowCheckedModeBanner: false,
          home: SplashScreen(),
          routes: <String, WidgetBuilder>{
            '/home': (BuildContext context) => HomePage()
          },
        );
      },
    );
  }
}
