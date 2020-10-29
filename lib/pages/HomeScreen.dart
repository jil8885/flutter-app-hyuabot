import 'package:chatbot/config/common.dart';
import 'package:chatbot/config/style.dart';
import 'package:chatbot/ui/bottombuttons/FoodButtons.dart';
import 'package:chatbot/ui/bottombuttons/LibraryButtons.dart';
import 'package:chatbot/ui/bottombuttons/MainButtons.dart';
import 'package:chatbot/ui/bottombuttons/TransportButtons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  // 홈화면 상태 빌드 함수
  @override
  Widget build(BuildContext context) {
    List _menus = [
      MainMenuButtons(),
      TransportMenuButtons(),
      FoodMenuButtons(),
      LibraryMenuButtons()
    ];

    // 전체 스크린
    return Scaffold(
        appBar: MainAppBar(),
        body: WillPopScope(
          child: Container(
              color: Color.fromRGBO(239, 244, 244, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                // 로고 부분
                Container(
                  padding: EdgeInsets.only(top: 5.0, right:18),
                  width: MediaQuery.of(context).size.width,
                  height: 150,
                  child: logoImage,
                ),
                // 메인 화면
                Expanded(
                  child: Container(
                    color: Color.fromRGBO(239, 244, 244, 0),
                    child: ListView.builder(
                      itemBuilder: (_, int index) => chatMessages[index],
                      itemCount: chatMessages.length,
                      padding: EdgeInsets.all(8.0),
                    ),
                  ),
                ),
                _menus[_menuSelected],
                // 메세지 전송 버튼
              ])),
          onWillPop: () {},
        ));
  }
}
