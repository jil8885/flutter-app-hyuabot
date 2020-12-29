library config.globals;

import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
    accentColor: const Color.fromARGB(255, 20, 75, 170),
    backgroundColor: const Color(0xffffffff),
    cardColor: const Color(0xffffffff),
    brightness: Brightness.light,
    fontFamily: "Godo",
    textTheme: const TextTheme(
      bodyText1: const TextStyle(fontSize: 16, color: Colors.black),
      bodyText2: const TextStyle(fontSize: 16, color: Colors.white),
    )
);

ThemeData darkTheme = ThemeData(
  accentColor: const Color(0xff9e9e9e),
  backgroundColor: const Color(0xff000000),
  cardColor: const Color(0x4dffffff),
  brightness: Brightness.dark,
  fontFamily: "Godo",
  textTheme: const TextTheme(
    bodyText1: const TextStyle(fontSize: 16, color: Colors.white),
    bodyText2: const TextStyle(fontSize: 16, color: Colors.black),
  )
);
