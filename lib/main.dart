import 'dart:io';

import 'package:chatbot/bloc/BusController.dart';
import 'package:chatbot/bloc/ChatListController.dart';
import 'package:chatbot/bloc/HeaderImageController.dart';
import 'package:chatbot/bloc/PhoneSearchController.dart';
import 'package:chatbot/bloc/ShuttleController.dart';
import 'package:chatbot/bloc/MetroController.dart';
import 'package:chatbot/ui/theme/ThemeManager.dart';
import 'package:chatbot/pages/HomeScreen.dart';
import 'package:chatbot/pages/SplashScreen.dart';
import 'package:chatbot/bloc/ButtonController.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:theme_provider/theme_provider.dart';

final mainButtonController = MainButtonPressed();
final subButtonController = SubButtonPressed();
final headerImageController = HeaderImageChanged();
final allShuttleController = FetchAllShuttleController();
final metroController = FetchMetroInfoController();
final busController = FetchBusInfoController();
final phoneSearcher = FetchPhoneController();


ChatListChanged chatController;
bool shuttleSheetOpened = false;
bool metroSheetOpened = false;
bool busSheetOpened = false;
Database database;

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  copyDatabase();
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
    chatController = ChatListChanged(context);
    return ThemeProvider(
      themes: [lightTheme, darkTheme],
      saveThemesOnChange: true,
      loadThemeOnInit: true,
      child: ThemeConsumer(
        child: Builder(
          builder: (themeContext) => MaterialApp(
            debugShowCheckedModeBanner: false,
            home: SplashScreen(),
            theme: ThemeProvider.themeOf(themeContext).data,
            routes: <String, WidgetBuilder>{
              '/home' : (BuildContext context) => new HomeScreen()
            },
          ),
        ),
      ),
    );
  }

}


