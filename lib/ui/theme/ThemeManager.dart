library config.globals;

import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

AppTheme lightTheme = AppTheme(
    id: 'light',
    data: ThemeData(
        accentColor: Color.fromARGB(255, 20, 75, 170),
        backgroundColor: Colors.white,
        cardColor: Color.fromARGB(160, 20, 75, 170),
        brightness: Brightness.light,
        textTheme: TextTheme(
          bodyText1: TextStyle(fontSize: 13, fontFamily: "Noto Sans KR", color: Colors.black),
          bodyText2: TextStyle(fontSize: 13, fontFamily: "Noto Sans KR", color: Colors.white),
        )
    ),
    description: "normal light theme",
);

AppTheme darkTheme = AppTheme(
    id: 'dark',
    data: ThemeData(
        accentColor: Color.fromARGB(255, 20, 75, 170),
        backgroundColor: Colors.black,
        cardColor: Colors.white70,
        brightness: Brightness.dark,
        textTheme: TextTheme(
          bodyText1: TextStyle(fontSize: 13, fontFamily: "Noto Sans KR", color: Colors.white),
          bodyText2: TextStyle(fontSize: 13, fontFamily: "Noto Sans KR", color: Colors.black),
        )
    ),
    description: "normal dark theme",
);
