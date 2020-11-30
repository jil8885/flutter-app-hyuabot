import 'dart:convert';


import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_hyuabot_v2/Config/Theme.dart';
import 'package:flutter_app_hyuabot_v2/Page/HomePage.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:get/get.dart';

import 'package:flutter_app_hyuabot_v2/Config/GlobalVars.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  savedThemeMode = await AdaptiveTheme.getThemeMode();
  runApp(Phoenix(child: MyApp()));
}


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
        light: lightTheme,
        dark: darkTheme,
        initial: savedThemeMode ?? AdaptiveThemeMode.system,
        builder: (theme, builder) => GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: theme,
          home: HomePage(),
      )
    );
  }
}
