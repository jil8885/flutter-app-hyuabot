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

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:path/path.dart';
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


ChatListChanged chatController;
bool shuttleSheetOpened = false;
bool metroSheetOpened = false;
bool busSheetOpened = false;
bool readingRoomOpened = false;
Timer timer;
Database database;

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  copyDatabase();
  savedThemeMode = await AdaptiveTheme.getThemeMode();
  runApp(MyApp());
}

void copyDatabase() async{
  var databasesPath = await getDatabasesPath();
  var path = join(databasesPath, "telephone.db");
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
          if(locale == null){
            debugPrint("language is null");
          }

          for (Locale supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale.languageCode ||
                supportedLocale.countryCode == locale.countryCode) {
              debugPrint("*language ok $supportedLocale");
              return supportedLocale;
            }
          }

          debugPrint("*language to fallback ${supportedLocales.first}");
          return supportedLocales.first;
        },
      ),
    );
  }

}


