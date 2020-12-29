import 'dart:convert';
import 'dart:developer';
import 'dart:io';


import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_hyuabot_v2/Config/Localization.dart';
import 'package:flutter_app_hyuabot_v2/Config/LocalizationDelegate.dart';
import 'package:flutter_app_hyuabot_v2/Config/Theme.dart';
import 'package:flutter_app_hyuabot_v2/Page/HomePage.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:get/get.dart';

import 'package:flutter_app_hyuabot_v2/Config/GlobalVars.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  savedThemeMode = await AdaptiveTheme.getThemeMode();
  prefManager = await StreamingSharedPreferences.instance;
  Firebase.initializeApp();
  fcmManager = FirebaseMessaging();
  var initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/launcher_icon');
  var initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
  flutterLocalNotificationsPlugin.initialize(initializationSettings);
  fcmManager.configure(
    onMessage: (Map<String, dynamic> message) async{
      final dynamic data = message['data'];
      await _showNotification(data["name"]);
      prefManager.setBool(data["name"], false);
    },
    onBackgroundMessage: backgroundMessageHandler
  );
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

Future<dynamic> backgroundMessageHandler(Map<String, dynamic> message) async {
  if (message.containsKey('data')) {
    final dynamic data = message['data'];
    prefManager.setBool(data["name"], false);
    await _showNotification(data["name"]);
    // fcmManager.unsubscribeFromTopic(data["name"]);
  }

  if (message.containsKey('notification')) {
    final dynamic notification = message['notification'];
  }
}

Future<void> _showNotification(String name) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
  AndroidNotificationDetails(
      'reading_room', 'HYUABOT Reading Room notification', 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker');
  const NotificationDetails platformChannelSpecifics =
  NotificationDetails(android: androidPlatformChannelSpecifics);
  print(prefManager.getString("localeCode", defaultValue: null).getValue());
  await flutterLocalNotificationsPlugin.show(0, TranslationManager(Locale(prefManager.getString("localeCode", defaultValue: "ko").getValue())).trans(name), TranslationManager(Locale(prefManager.getString("localeCode", defaultValue: "ko").getValue())).trans(name), platformChannelSpecifics, payload: 'item x');
}

class MyApp extends StatelessWidget {
  final FirebaseAnalytics analytics = FirebaseAnalytics();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    Preference<String> _localeCode = prefManager.getString("localeCode", defaultValue: "ko");

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
            switch(_localeCode.getValue()){
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
