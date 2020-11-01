import 'package:chatbot/bloc/HeaderImageController.dart';
import 'package:chatbot/main.dart';
import 'package:chatbot/config/common.dart';
import 'package:chatbot/config/style.dart';
import 'package:chatbot/ui/ChatMessage.dart';
import 'package:chatbot/ui/bottombuttons/FoodButtons.dart';
import 'package:chatbot/ui/bottombuttons/LibraryButtons.dart';
import 'package:chatbot/ui/bottombuttons/MainButtons.dart';
import 'package:chatbot/ui/bottombuttons/TransportButtons.dart';
import 'package:chatbot/ui/theme/ThemeManager.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';


class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List _subMenus = [
      TransportMenuButtons(),
      FoodMenuButtons(),
      LibraryMenuButtons(),
      backMenuButton(context),
    ];

    headerImageController.setHeaderImage(getImagePath(context, "header-default.png"));
    // 전체 스크린
    return Scaffold(
        appBar: MainAppBar(),
        body: DoubleBackToCloseApp(
          child: Container(
              color: Theme.of(context).backgroundColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                // 로고 부분
                StreamBuilder<Image>(
                  stream: headerImageController.headerImage,
                  builder: (context, snapshot) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      height: 150,
                      child: snapshot.data,
                    );
                  }
                ),
                // 메인 화면
                Expanded(
                  child: Container(
                    color: Theme.of(context).backgroundColor,
                    child: StreamBuilder<List<ChatMessage>>(
                      stream: chatController.chatList,
                      builder: (context, snapshot) {
                        if(snapshot.hasData){
                          return ListView.builder(
                            itemBuilder: (_, int index) => snapshot.data[index],
                            itemCount: snapshot.data.length,
                            padding: EdgeInsets.all(8.0),
                          );
                        } else {
                          return CircularProgressIndicator();
                        }
                      }
                    ),
                  ),
                ),
                StreamBuilder<int>(
                  stream: mainButtonController.mainButtonIndex,
                  builder: (_, snapshot){
                    if(!snapshot.hasData || snapshot.data == -1 || snapshot.data > _subMenus.length){
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
