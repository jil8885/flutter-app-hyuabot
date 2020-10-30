// common variables to share from other file

import 'package:chatbot/main.dart';
import 'package:flutter/material.dart';

// Shared Variables for home screen
Image logoImage = Image.asset('assets/images/logo-default.png');


Widget backMenuButton(){
  return IconButton(
    icon: Icon(Icons.arrow_back),
    onPressed: (){
      logoImage = Image.asset('assets/images/logo-default.png');
      chatController.resetChatList();
      mainButtonController.backToMain();
      subButtonController.resetSubButtonIndex();
    },
  );
}
