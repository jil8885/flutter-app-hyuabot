// common variables to share from other file

import 'package:chatbot/ui/ChatMessage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Shared Variables for home screen
Image logoImage = Image.asset('assets/images/logo-default.png');
List<ChatMessage> chatMessages = [ChatMessage(text: "반갑하냥~내가 너를 도와줄게!")];
int pressedMainButton = -1;
int pressedSubButton = -1;

Widget backMenuButton(){
  return IconButton(
    icon: Icon(Icons.arrow_back),
    onPressed: (){
      logoImage = Image.asset('assets/images/logo-default.png');
      chatMessages.removeLast();
    },
  );
}
