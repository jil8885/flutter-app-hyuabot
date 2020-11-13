import 'package:chatbot/bloc/ChatListController.dart';
import 'package:chatbot/bloc/HeaderImageController.dart';
import 'package:chatbot/bloc/ShuttleController.dart';
import 'package:chatbot/bloc/MetroController.dart';
import 'package:chatbot/ui/theme/ThemeManager.dart';
import 'package:flutter/material.dart';

import 'package:chatbot/pages/HomeScreen.dart';
import 'package:chatbot/pages/SplashScreen.dart';
import 'package:theme_provider/theme_provider.dart';

import 'bloc/ButtonController.dart';

final mainButtonController = MainButtonPressed();
final subButtonController = SubButtonPressed();
final headerImageController = HeaderImageChanged();
final allShuttleController = FetchAllShuttleController();
final metroController = FetchMetroInfoController();

ChatListChanged chatController;
bool shuttleSheetOpened = false;
bool metroSheetOpened = false;

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
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


