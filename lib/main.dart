import 'dart:io';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_hyuabot_v2/Config/LocalizationDelegate.dart';
import 'package:flutter_app_hyuabot_v2/Config/Theme.dart';
import 'package:flutter_app_hyuabot_v2/Page/HomePage.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:get/get.dart';

import 'package:flutter_app_hyuabot_v2/Config/GlobalVars.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  savedThemeMode = await AdaptiveTheme.getThemeMode();
  prefManager = await SharedPreferences.getInstance();
  if(prefManager.getString("localeCode").isNull){
    prefManager.setString("localeCode", "ko_KR");
  }
  if(prefManager.getBool("reading_room_1").isNull || prefManager.getBool("reading_room_2").isNull || prefManager.getBool("reading_room_3").isNull || prefManager.getBool("reading_room_4").isNull){
    prefManager.setBool("reading_room_1", false);
    prefManager.setBool("reading_room_2", false);
    prefManager.setBool("reading_room_3", false);
    prefManager.setBool("reading_room_4", false);
  }
  Firebase.initializeApp();
  copyDatabase();
  runApp(Phoenix(child: MyApp()));
}

void copyDatabase() async {
  final String path = join(await getDatabasesPath(), "information.db");
  await deleteDatabase(path);

  try {
    await Directory(dirname(path)).create(recursive: true);
  } catch (_) {}
  ByteData data = await rootBundle.load(join("assets/databases", "information.db"));
  List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  await new File(path).writeAsBytes(bytes, flush: true);
}


class MyApp extends StatelessWidget {
  final FirebaseAnalytics analytics = FirebaseAnalytics();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    String _localeCode = prefManager.getString("localeCode");

    return AdaptiveTheme(
        light: lightTheme,
        dark: darkTheme,
        initial: savedThemeMode ?? AdaptiveThemeMode.system,
        builder: (theme, darkTheme) => GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: theme,
          darkTheme: darkTheme,
          home: HomePage(),
          navigatorObservers: [FirebaseAnalyticsObserver(analytics: analytics)],
          supportedLocales: [const Locale('ko', 'KR'), const Locale('en', 'US'), const Locale('zh')],
          localizationsDelegates: [const TranslationsDelegate(), GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate],
          localeResolutionCallback: (Locale locale, Iterable<Locale> supportedLocales){
            switch(_localeCode){
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
