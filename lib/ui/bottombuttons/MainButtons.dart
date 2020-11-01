import 'package:chatbot/main.dart';
import 'package:chatbot/pages/SettingScreen.dart';
import 'package:flutter/material.dart';

import '../ChatMessage.dart';

class MainMenuButtons extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _makeFuncButton(context, "원하는 교통수단을 골라달라냥!", "assets/images/logo-bus.png", "assets/images/shared/icon-bus.png", "assets/images/shared/icon-bus-active.png", "교통", 0),
          _makeFuncButton(context, "메뉴를 알고 싶은 식당을 골라달라냥!", "assets/images/logo-food.png", "assets/images/shared/icon-food.png", "assets/images/shared/icon-food-active.png", "학식", 1),
          _makeFuncButton(context, "알고 싶은 정보를 골라달라냥!", "assets/images/logo-book.png", "assets/images/shared/icon-book.png", "assets/images/shared/icon-book-active.png", "도서관", 2),
          _makeFuncButton(context, "밑에서 원하는 기관을 검색하라냥!", "assets/images/logo-default.png", "assets/images/shared/icon-phone.png", "assets/images/shared/icon-phone-active.png", "전화부", 3),
          _settingButtons(context),
        ],
      ),
    );
  }

  Widget _makeFuncButton(BuildContext context, String msgText, String logoPath, String icon, String iconPressed, String buttonText, int index){
    return StreamBuilder<int>(
      stream: mainButtonController.mainButtonIndex,
      builder: (context, snapshot) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: RaisedButton(
            child: Row(children: <Widget>[
              Image.asset(snapshot.data == index ? iconPressed:icon, height: 25, width: 25),
              Text(
                buttonText,
                style: TextStyle(fontSize: 12, color: snapshot.data == index ? Colors.white : Colors.black),
              )
            ]),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0),),
            color: snapshot.data == index ? Theme.of(context).accentColor : Colors.white,
            onPressed: (){
              mainButtonController.updateMainButtonIndex(index);
              chatController.setChatList(ChatMessage(text: msgText,));
            },
          ),
        );
      }
    );
  }

  Widget _settingButtons(BuildContext context) {
    return RaisedButton(
      child: Text("설정", style: TextStyle(
          fontSize: 11, fontFamily: "Noto Sans KR", color: Colors.black)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0),),
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SettingScreen()));
      },
      elevation: 6,
      color: Colors.white,
      focusColor: Colors.blue,
    );
  }
}