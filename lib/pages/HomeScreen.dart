import 'package:chatbot/main.dart';
import 'package:chatbot/config/common.dart';
import 'package:chatbot/config/style.dart';
import 'package:chatbot/ui/ChatMessage.dart';
import 'package:chatbot/ui/bottombuttons/FoodButtons.dart';
import 'package:chatbot/ui/bottombuttons/LibraryButtons.dart';
import 'package:chatbot/ui/bottombuttons/MainButtons.dart';
import 'package:chatbot/ui/bottombuttons/TransportButtons.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 홈화면 상태 빌드 함수
  @override
  Widget build(BuildContext context) {
    List _subMenus = [
      TransportMenuButtons(),
      FoodMenuButtons(),
      LibraryMenuButtons(),
      backMenuButton(),
    ];

    // 전체 스크린
    return Scaffold(
        appBar: MainAppBar(),
        body: DoubleBackToCloseApp(
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
                    child: StreamBuilder<List<ChatMessage>>(
                      stream: chatController.chatList,
                      builder: (context, snapshot) {
                        return ListView.builder(
                          itemBuilder: (_, int index) => snapshot.data[index],
                          itemCount: snapshot.data.length,
                          padding: EdgeInsets.all(8.0),
                        );
                      }
                    ),
                  ),
                ),
                StreamBuilder<int>(
                  stream: mainButtonController.mainButtonIndex,
                  builder: (_, snapshot){
                    if(snapshot.data == -1 || snapshot.data > _subMenus.length || snapshot.data == null){
                      return MainMenuButtons();
                    }
                    return _subMenus[snapshot.data];
                  },
                ),
              ])),
          snackBar: const SnackBar(content: Text("하냥이와 함께 좋은 하루 되라냥!", textAlign: TextAlign.center,),),
        ));
  }
}
