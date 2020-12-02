library config.globals;

import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
    accentColor: Color.fromARGB(255, 20, 75, 170),
    backgroundColor: Colors.white,
    cardColor: Color.fromARGB(160, 20, 75, 170),
    brightness: Brightness.light,
    textTheme: TextTheme(
      bodyText1: TextStyle(fontSize: 16, color: Colors.black, fontFamily: "Godo"),
      bodyText2: TextStyle(fontSize: 16, color: Colors.white, fontFamily: "Godo"),
    )
);

ThemeData darkTheme = ThemeData(
  accentColor: Colors.grey,
  // accentColor: Color.fromARGB(255, 20, 75, 170),
  backgroundColor: Colors.black,
  cardColor: Colors.white70,
  brightness: Brightness.dark,
  textTheme: TextTheme(
    bodyText1: TextStyle(fontSize: 16, color: Colors.white, fontFamily: "Godo"),
    bodyText2: TextStyle(fontSize: 16, color: Colors.black, fontFamily: "Godo"),
  )
);
