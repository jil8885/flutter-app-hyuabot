library config.globals;

import 'package:chatbot/ui/theme/AppTheme.dart';
import 'package:flutter/material.dart';

AppTheme currentTheme = AppTheme();

ThemeData lightTheme = ThemeData(
  accentColor: Color.fromARGB(255, 20, 75, 170),
  backgroundColor: Color.fromRGBO(239, 244, 244, 0),
  cardColor: Color.fromARGB(160, 20, 75, 170),
  brightness: Brightness.light,
  textTheme: TextTheme(
    bodyText1: TextStyle(fontSize: 11, fontFamily: "Noto Sans KR", color: Colors.black),
    bodyText2: TextStyle(fontSize: 11, fontFamily: "Noto Sans KR", color: Colors.white),
  )
);
ThemeData darkTheme = ThemeData(
    accentColor: Color.fromARGB(255, 20, 75, 170),
    backgroundColor: Colors.black38,
    cardColor: Colors.white70,
    brightness: Brightness.dark,
    textTheme: TextTheme(
      bodyText1: TextStyle(fontSize: 11, fontFamily: "Noto Sans KR", color: Colors.white),
      bodyText2: TextStyle(fontSize: 11, fontFamily: "Noto Sans KR", color: Colors.black),
    )
);