import 'package:chatbot/bloc/ChatListController.dart';
import 'package:chatbot/ui/theme/ThemeManager.dart';
import 'package:flutter/material.dart';

import 'package:chatbot/pages/HomeScreen.dart';
import 'package:chatbot/pages/SplashScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:theme_provider/theme_provider.dart';

import 'bloc/ButtonController.dart';

final mainButtonController = MainButtonPressed();
final subButtonController = SubButtonPressed();
final chatController = ChatListChanged();

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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


