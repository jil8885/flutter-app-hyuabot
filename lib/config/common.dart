// common variables to share from other file

import 'package:chatbot/main.dart';
import 'package:chatbot/ui/theme/ThemeManager.dart';
import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

// Shared Variables for home screen
Image logoImage = Image.asset('assets/images/logo-default.png');


Widget backMenuButton(BuildContext context){
  return IconButton(
    icon: Icon(Icons.arrow_back),
    onPressed: (){
      logoImage = ThemeProvider.themeOf(context) == lightTheme ? Image.asset('assets/images/logo-default.png') : Image.asset('assets/images/dark/logo-default-dark.png');
      chatController.resetChatList();
      mainButtonController.backToMain();
      subButtonController.resetSubButtonIndex();
    },
  );
}
