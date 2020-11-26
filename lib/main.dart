import 'dart:async';
import 'dart:io';

import 'package:chatbot/bloc/BusController.dart';
import 'package:chatbot/bloc/ChatListController.dart';
import 'package:chatbot/bloc/HeaderImageController.dart';
import 'package:chatbot/bloc/PhoneSearchController.dart';
import 'package:chatbot/bloc/ReadingRoomController.dart';
import 'package:chatbot/bloc/ShuttleController.dart';
import 'package:chatbot/bloc/MetroController.dart';
import 'package:chatbot/config/LocalizationDelegate.dart';
import 'package:chatbot/ui/theme/ThemeManager.dart';
import 'package:chatbot/pages/HomeScreen.dart';
import 'package:chatbot/pages/SplashScreen.dart';
import 'package:chatbot/bloc/ButtonController.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:adaptive_theme/adaptive_theme.dart';

AdaptiveThemeMode savedThemeMode;

final mainButtonController = MainButtonPressed();
final subButtonController = SubButtonPressed();
final headerImageController = HeaderImageChanged();
final allShuttleController = FetchAllShuttleController();
final metroController = FetchMetroInfoController();
final busController = FetchBusInfoController();
final phoneSearcher = FetchPhoneController();
final readingRoomController = ReadingRoomController();
final fcm = FirebaseMessaging();


ChatListChanged chatController;
bool shuttleSheetOpened = false;
bool metroSheetOpened = false;
bool busSheetOpened = false;
bool readingRoomOpened = false;
String localeCode;
SharedPreferences prefs;
Timer timer;
Database database;

Future<dynamic> _backgroundMsgHandler (Map<String, dynamic> message) async {
  String name = message['notification']['title'];
  if (name.contains("1")) {
    fcm.unsubscribeFromTopic("room_1_ko_KR");
    fcm.unsubscribeFromTopic("room_1_en_US");
    fcm.unsubscribeFromTopic("room_1_zh");
    prefs.setBool("room_1_ko_KR", false);
    prefs.setBool("room_1_en_US", false);
    prefs.setBool("room_1_zh", false);
  } else if (name.contains("2")) {
    fcm.unsubscribeFromTopic("room_2_ko_KR");
    fcm.unsubscribeFromTopic("room_2_en_US");
    fcm.unsubscribeFromTopic("room_2_zh");
    prefs.setBool("room_2_ko_KR", false);
    prefs.setBool("room_2_en_US", false);
    prefs.setBool("room_2_zh", false);
  } else if (name.contains("3")) {
    fcm.unsubscribeFromTopic("room_3_ko_KR");
    fcm.unsubscribeFromTopic("room_3_en_US");
    fcm.unsubscribeFromTopic("room_3_zh");
    prefs.setBool("room_3_ko_KR", false);
    prefs.setBool("room_3_en_US", false);
    prefs.setBool("room_3_zh", false);
  } else if (name.contains("4")) {
    fcm.unsubscribeFromTopic("room_4_ko_KR");
    fcm.unsubscribeFromTopic("room_4_en_US");
    fcm.unsubscribeFromTopic("room_4_zh");
    prefs.setBool("room_4_ko_KR", false);
    prefs.setBool("room_4_en_US", false);
    prefs.setBool("room_4_zh", false);
  }
}

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  copyDatabase();

  if(!kReleaseMode) {
    print(await fcm.getToken());
  }
  fcm.configure(
      onMessage:  (Map<String, dynamic> message) async {
        String name = message['notification']['title'];
        String msg = "";
        if(name.contains("1")){
          fcm.unsubscribeFromTopic("room_1_ko_KR");
          fcm.unsubscribeFromTopic("room_1_en_US");
          fcm.unsubscribeFromTopic("room_1_zh");
          prefs.setBool("room_1_ko_KR", false);
          prefs.setBool("room_1_en_US", false);
          prefs.setBool("room_1_zh", false);
          msg = "제1열람실";
        } else if(name.contains("2")){
          fcm.unsubscribeFromTopic("room_2_ko_KR");
          fcm.unsubscribeFromTopic("room_2_en_US");
          fcm.unsubscribeFromTopic("room_2_zh");
          prefs.setBool("room_2_ko_KR", false);
          prefs.setBool("room_2_en_US", false);
          prefs.setBool("room_2_zh", false);
          msg = "제2열람실";
        } else if(name.contains("3")){
          fcm.unsubscribeFromTopic("room_3_ko_KR");
          fcm.unsubscribeFromTopic("room_3_en_US");
          fcm.unsubscribeFromTopic("room_3_zh");
          prefs.setBool("room_3_ko_KR", false);
          prefs.setBool("room_3_en_US", false);
          prefs.setBool("room_3_zh", false);
          msg = "제3열람실";
        } else if(name.contains("4")){
          fcm.unsubscribeFromTopic("room_4_ko_KR");
          fcm.unsubscribeFromTopic("room_4_en_US");
          fcm.unsubscribeFromTopic("room_4_zh");
          prefs.setBool("room_4_ko_KR", false);
          prefs.setBool("room_4_en_US", false);
          prefs.setBool("room_4_zh", false);
          msg = "제4열람실";
        }
        if(msg != ""){
          Fluttertoast.showToast(msg: "$msg에서 자리를 발견했다냥! 알림을 종료할게요!");
        }
      },
      onBackgroundMessage: _backgroundMsgHandler,
  );
  savedThemeMode = await AdaptiveTheme.getThemeMode();
  runApp(Phoenix(child: MyApp()));
}

void copyDatabase() async{
  var databasesPath = await getDatabasesPath();
  var path = join(databasesPath, "telephone.db");
  prefs = await SharedPreferences.getInstance();
  localeCode = prefs.getString("localeCode");
// delete existing if any
  await deleteDatabase(path);

// Make sure the parent directory exists
  try {
    await Directory(dirname(path)).create(recursive: true);
  } catch (_) {}

// Copy from asset
  ByteData data = await rootBundle.load(join("assets/database", "telephone.db"));
  List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  await new File(path).writeAsBytes(bytes, flush: true);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: lightTheme,
      dark: darkTheme,
      initial: savedThemeMode ?? AdaptiveThemeMode.system,
      builder: (theme, darkTheme) => MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
        theme: theme,
        routes: <String, WidgetBuilder>{
          '/home' : (BuildContext context) => new HomeScreen()
        },
        supportedLocales: [const Locale('ko', 'KR'), const Locale('en', 'US'), const Locale('zh')],
        localizationsDelegates: [const TranslationsDelegate(), GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate],
        localeResolutionCallback: (Locale locale, Iterable<Locale> supportedLocales){
          var localeCode = prefs.getString("localeCode");
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
      ),
    );
  }

}


