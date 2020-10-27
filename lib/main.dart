import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:chatbot/pages/HomeScreen.dart';
import 'package:chatbot/pages/SplashScreen.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:shared_preferences/shared_preferences.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(Phoenix(child: EasyLocalization(child: MyApp(), supportedLocales: [Locale('ko', 'KR'), Locale('en', 'US')], path: 'assets/translations')));
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future<Locale> locale = getLocale();
    return FutureBuilder(
      future: locale,
      builder: (BuildContext context, AsyncSnapshot<Locale> snapshot){
        if(snapshot.hasError){
            return MaterialApp(
                debugShowCheckedModeBanner: false,
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                locale: context.locale,
                theme: ThemeData(
                primarySwatch: Colors.blue,
                visualDensity: VisualDensity.adaptivePlatformDensity,
                ),
              home: Center(child: Text(snapshot.error.toString(), style: TextStyle(fontSize: 10),),),
            );
        }else{
          if(snapshot.data != null){
            context.locale = snapshot.data;
          }
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            theme: ThemeData(
              primarySwatch: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: SplashScreen(),
            routes: <String, WidgetBuilder>{
              '/home' : (BuildContext context) => new HomeScreen()
            },
          );
        }
      },
    );
  }

  Future<Locale> getLocale() async{
    SharedPreferences _prefManager = await SharedPreferences.getInstance();
    List<String> localeCode = _prefManager.getStringList("language");
    if(localeCode!=null) {
      return Locale(localeCode[0], localeCode[1]);
    } else {
      return null;
    }
  }
}


