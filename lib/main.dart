import 'package:chatbot/bloc/ChatListChanged.dart';
import 'package:chatbot/ui/theme/ThemeManager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:chatbot/pages/HomeScreen.dart';
import 'package:chatbot/pages/SplashScreen.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bloc/ButtonPressed.dart';

final mainButtonController = MainButtonPressed();
final subButtonController = SubButtonPressed();
final chatController = ChatListChanged();

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
      Phoenix(
          child: EasyLocalization(
              child: MyApp(),
              supportedLocales: [Locale('ko', 'KR'), Locale('en', 'US')],
              path: 'assets/translations'
          )
      )
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future<Map<String, dynamic>> _pref = getPref();

    return FutureBuilder(
        future: _pref,
        builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot){
          if(snapshot.hasError){
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                locale: context.locale,
                theme: ThemeData.light(),
                darkTheme: ThemeData.dark(),
                themeMode: currentTheme.currentTheme(),
                home: Center(child: Text(snapshot.error.toString(), style: TextStyle(fontSize: 10),),),
              );
          }else{
            if(snapshot.data != null){
              context.locale = snapshot.data["locale"];
              print(snapshot.data["darkMode"]);
              if(snapshot.data["darkMode"] == 'true' || snapshot.data["darkMode"] == 'false'){
                currentTheme.setTheme(snapshot.data["darkMode"] == 'true');
              } else{
                currentTheme.setTheme(MediaQueryData.fromWindow(WidgetsBinding.instance.window).platformBrightness == Brightness.dark);
              }
            }
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              theme: lightTheme,
              darkTheme: darkTheme,
              themeMode: currentTheme.currentTheme(),
              home: SplashScreen(),
              routes: <String, WidgetBuilder>{
                '/home' : (BuildContext context) => new HomeScreen()
              },
            );
          }
        },
    );
  }

  Future<Map<String, dynamic>> getPref() async{
    SharedPreferences _prefManager = await SharedPreferences.getInstance();
    Map<String, dynamic> _prefs = {};

    // Get Application Locale
    List<String> localeCode = _prefManager.getStringList("language");
    if(localeCode!=null) {
      _prefs["locale"] = Locale(localeCode[0], localeCode[1]);
    } else {
      _prefs["locale"] =  null;
    }

    // Get isDarkMode
    String isDarkMode = _prefManager.getString("darkMode");
    if(isDarkMode != null){
      _prefs["darkMode"] = isDarkMode;
    } else {
      _prefs["darkMode"] = "auto";
    }

    return _prefs;
  }
}


