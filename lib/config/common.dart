// common variables to share from other file

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:chatbot/main.dart';
import 'package:chatbot/ui/theme/ThemeManager.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Shared Variables for home screen
Image logoImage;

String getImagePath(BuildContext context, String fileName){
  final directory = AdaptiveTheme.of(context).theme.backgroundColor == Colors.white? 'assets/images/light/' : 'assets/images/dark/';
  return directory + fileName;
}


Widget backMenuButton(BuildContext context){
  return IconButton(
    icon: Icon(Icons.arrow_back),
    onPressed: (){
      headerImageController.setHeaderImage(getImagePath(context, "header-default.png"));
      chatController.resetChatList(context);
      mainButtonController.backToMain();
      subButtonController.resetSubButtonIndex();
    },
  );
}

DateTime getTimeFromString(String str, DateTime now){
  DateTime time = DateFormat('HH:mm').parse(str);
  return DateTime(now.year, now.month, now.day, time.hour, time.minute);
}
