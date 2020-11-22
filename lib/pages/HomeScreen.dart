import 'package:chatbot/main.dart';
import 'package:chatbot/config/common.dart';
import 'package:chatbot/config/style.dart';
import 'package:chatbot/ui/ChatMessage.dart';
import 'package:chatbot/ui/bottom_button/TransportButtons.dart';
import 'package:chatbot/ui/bottom_button/MainButtons.dart';
import 'package:chatbot/ui/bottom_button/FoodButtons.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomeScreenStates();
}

class HomeScreenStates extends State<HomeScreen>{
  @override
  Widget build(BuildContext context) {
    List _subMenus = [
      TransportMenuButtons(),
      FoodMenuButtons(),
      backMenuButton(context),
    ];
    DateTime _lastPressedAt;
    int _selectedIndex;

    headerImageController.setHeaderImage(getImagePath(context, "header-default.png"));
    // 전체 스크린
    return Scaffold(
        appBar: MainAppBar(),
        body: WillPopScope(
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
                StreamBuilder<Map<String, dynamic>>(
                  stream: mainButtonController.mainButtonIndex,
                  builder: (_, snapshot){
                    if(snapshot.hasData){
                      _selectedIndex = snapshot.data['index'];
                    }
                    return AnimatedSwitcher(
                        duration: Duration(microseconds: 400),
                        child: !snapshot.hasData || !snapshot.data.containsKey('index') || snapshot.data['index'] == -1 || snapshot.data['index'] > _subMenus.length?MainMenuButtons(this, MediaQuery.of(context).size.width * .015):_subMenus[snapshot.data['index']],
                    );
                  },
                ),
              ])),
          onWillPop: () async{
            if(_selectedIndex <= _subMenus.length && _selectedIndex >= 0){
              headerImageController.setHeaderImage(getImagePath(context, "header-default.png"));
              chatController.resetChatList(context);
              mainButtonController.backToMain();
              subButtonController.resetSubButtonIndex();
              return false;
            }
            if(_lastPressedAt == null || DateTime.now().difference(_lastPressedAt) > Duration(seconds: 1)){
                Fluttertoast.showToast(
                    msg: "하냥이랑 함께 좋은 하루 되라냥!\n뒤로 가기 버튼을 한번 더 눌러주세요!",
                    toastLength: Toast.LENGTH_SHORT,
                    timeInSecForIosWeb: 1,
                    textColor: Theme.of(context).backgroundColor==Colors.black?Colors.black:Colors.white,
                    backgroundColor: Theme.of(context).backgroundColor==Colors.black?Colors.white:Colors.black,
                    gravity: ToastGravity.SNACKBAR
                );
                _lastPressedAt = DateTime.now();
                return false;
              }
            return true;
          }
        ));
  }
}
