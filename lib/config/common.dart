// common variables to share from other file

import 'package:chatbot/main.dart';
import 'package:chatbot/ui/theme/ThemeManager.dart';
import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

// Shared Variables for home screen
Image logoImage;

String getImagePath(BuildContext context, String file_name){
  final directory = ThemeProvider.themeOf(context) == lightTheme ? 'assets/images/light/' : 'assets/images/dark/';
  return directory + file_name;
}


Widget backMenuButton(BuildContext context){
  return IconButton(
    icon: Icon(Icons.arrow_back),
    onPressed: (){
      logoImage = Image.asset(getImagePath(context, "header-default.png"));
      chatController.resetChatList();
      mainButtonController.backToMain();
      subButtonController.resetSubButtonIndex();
    },
  );
}
