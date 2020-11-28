library config.globals;

import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
    accentColor: Color.fromARGB(255, 20, 75, 170),
    backgroundColor: Colors.white,
    cardColor: Color.fromARGB(160, 20, 75, 170),
    brightness: Brightness.light,
    textTheme: TextTheme(
      bodyText1: TextStyle(fontSize: 13, color: Colors.black),
      bodyText2: TextStyle(fontSize: 13, color: Colors.white),
    )
);

ThemeData darkTheme = ThemeData(
    accentColor: Color.fromARGB(255, 20, 75, 170),
    backgroundColor: Colors.black,
    cardColor: Colors.white70,
    brightness: Brightness.dark,
    textTheme: TextTheme(
      bodyText1: TextStyle(fontSize: 13, color: Colors.white),
      bodyText2: TextStyle(fontSize: 13, color: Colors.black),
    )
);
