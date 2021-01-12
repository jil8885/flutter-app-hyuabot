import 'dart:io';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_hyuabot_v2/Config/LocalizationDelegate.dart';
import 'package:flutter_app_hyuabot_v2/Config/Theme.dart';
import 'package:flutter_app_hyuabot_v2/Page/HomePage.dart';
import 'package:flutter_app_hyuabot_v2/Page/SplashScreen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:get/get.dart';

import 'package:flutter_app_hyuabot_v2/Config/GlobalVars.dart';
import 'package:path/path.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

const MethodChannel readingRoomChannel = MethodChannel('kobuggi.app/reading_room_notification');
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject = BehaviorSubject<ReceivedNotification>();
final BehaviorSubject<String> selectNotificationSubject = BehaviorSubject<String>();


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // FCM
  fcmManager = FirebaseMessaging();

  // Alarm
  final NotificationAppLaunchDetails notificationAppLaunchDetails = await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  const AndroidInitializationSettings _initialSettingsAndroid = AndroidInitializationSettings('@mipmap/launcher_icon');
  const InitializationSettings _settings = InitializationSettings(android: _initialSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(_settings,
      onSelectNotification: whenSelectNotification);

  // Pref
  savedThemeMode = await AdaptiveTheme.getThemeMode();
  prefManager = await SharedPreferences.getInstance();
  Firebase.initializeApp();
  runApp(Phoenix(child: MyApp(notificationAppLaunchDetails)));
}

Future whenSelectNotification(String payload) async{
  debugPrint(payload);
  prefManager.setBool(payload, false);
  fcmManager.unsubscribeFromTopic("$payload.ko_KR");
  fcmManager.unsubscribeFromTopic("$payload.en_US");
  fcmManager.unsubscribeFromTopic("$payload.zh");
  readingRoomController.fetchAlarm();
  selectNotificationSubject.add(payload);
}

class ReceivedNotification {
  ReceivedNotification({
    @required this.id,
    @required this.title,
    @required this.body,
    @required this.payload,
  });

  final int id;
  final String title;
  final String body;
  final String payload;
}

class MyApp extends StatelessWidget {
  MyApp(
      this.notificationAppLaunchDetails, {
        Key key,
      }) : super(key: key);

  final NotificationAppLaunchDetails notificationAppLaunchDetails;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    analytics = FirebaseAnalytics();
    return AdaptiveTheme(
        light: lightTheme,
        dark: darkTheme,
        initial: savedThemeMode ?? AdaptiveThemeMode.system,
        builder: (theme, darkTheme) => GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: theme,
          darkTheme: darkTheme,
          home: SplashScreen(),
          routes: <String, WidgetBuilder>{
            '/HomeScreen': (BuildContext context) => HomePage(notificationAppLaunchDetails)
          },
          builder: (context, child) {
            return MediaQuery(
              child: child,
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            );
          },
          navigatorObservers: [FirebaseAnalyticsObserver(analytics: analytics)],
          supportedLocales: [const Locale('ko', 'KR'), const Locale('en', 'US'), const Locale('zh')],
          localizationsDelegates: [const TranslationsDelegate(), GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate],
          localeResolutionCallback: (Locale locale, Iterable<Locale> supportedLocales){
            final String _localeCode = prefManager.getString("localeCode");
            if(_localeCode.isNull){
              prefManager.setString("localeCode", "ko_KR");
            }
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
