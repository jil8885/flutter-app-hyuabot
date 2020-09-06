import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:chatbot/pages/HomeScreen.dart';
import 'package:chatbot/pages/SplashScreen.dart';

void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
}


