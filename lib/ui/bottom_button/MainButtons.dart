import 'package:chatbot/config/common.dart';
import 'package:chatbot/main.dart';
import 'package:chatbot/pages/HomeScreen.dart';
import 'package:chatbot/pages/SettingScreen.dart';
import 'package:chatbot/ui/bottom_sheet/TelephoneSheets.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../ChatMessage.dart';

class MainMenuButtons extends StatelessWidget{
  HomeScreenStates homePage;
  MainMenuButtons(this.homePage);
  @override
  Widget build(BuildContext context) {
    Widget mainButton =  Row(
      children: [
        _makeFuncButton(context, "원하는 교통수단을 골라달라냥!", getImagePath(context, "header-bus.png"), "assets/images/shared/icon-bus.png", "assets/images/shared/icon-bus-active.png", "교통", 0),
        _makeFuncButton(context, "메뉴를 알고 싶은 식당을 골라달라냥!", getImagePath(context, "header-food.png"), "assets/images/shared/icon-food.png", "assets/images/shared/icon-food-active.png", "학식", 1),
        _makeFuncButton(context, "알고 싶은 정보를 골라달라냥!", getImagePath(context, "header-book.png"), "assets/images/shared/icon-book.png", "assets/images/shared/icon-book-active.png", "도서관", 2),
        _makeFuncButton(context, "밑에서 원하는 기관을 검색하라냥!", getImagePath(context, "header-default.png"), "assets/images/shared/icon-phone.png", "assets/images/shared/icon-phone-active.png", "전화부", 3),
        IconButton(icon: Icon(Icons.keyboard_arrow_up, color: Theme.of(context).backgroundColor == Colors.black? Colors.white : Colors.black,), onPressed: (){
          mainButtonController.updateMainButtonExpand(expand: true);
          this.homePage.setState(() {});
        })
      ],
    );

    Widget mainButtonExpanded =  Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
              _settingButtons(context)
          ],
        ),
        Row(
          children: [
            _makeFuncButton(context, "원하는 교통수단을 골라달라냥!", getImagePath(context, "header-bus.png"), "assets/images/shared/icon-bus.png", "assets/images/shared/icon-bus-active.png", "교통", 0),
            _makeFuncButton(context, "메뉴를 알고 싶은 식당을 골라달라냥!", getImagePath(context, "header-food.png"), "assets/images/shared/icon-food.png", "assets/images/shared/icon-food-active.png", "학식", 1),
            _makeFuncButton(context, "알고 싶은 정보를 골라달라냥!", getImagePath(context, "header-book.png"), "assets/images/shared/icon-book.png", "assets/images/shared/icon-book-active.png", "도서관", 2),
            _makeFuncButton(context, "밑에서 원하는 기관을 검색하라냥!", getImagePath(context, "header-default.png"), "assets/images/shared/icon-phone.png", "assets/images/shared/icon-phone-active.png", "전화부", 3),
            IconButton(icon: Icon(Icons.keyboard_arrow_down, color: Theme.of(context).backgroundColor == Colors.black? Colors.white : Colors.black,), onPressed: (){
              mainButtonController.updateMainButtonExpand(expand: false);
              this.homePage.setState(() {});
            })
          ],
        )
      ],
    );


    return StreamBuilder<Map<String, dynamic>>(
      stream: mainButtonController.mainButtonIndex,
      builder: (context, snapshot){
        return AnimatedSwitcher(
            duration: Duration(milliseconds: 1),
            child: snapshot.hasData && snapshot.data['expanded']? mainButtonExpanded:mainButton,
        );
      },
    );
  }

  Widget _makeFuncButton(BuildContext context, String msgText, String logoPath, String icon, String iconPressed, String buttonText, int index){
    double _buttonWidth = 0;
    if(buttonText.length == 2){
      _buttonWidth = 70;
    } else{
      _buttonWidth = 80;
    }
    return StreamBuilder<Map<String, dynamic>>(
      stream: mainButtonController.mainButtonIndex,
      builder: (context, snapshot) {
        if(!snapshot.hasData){
          return Container();
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 8),
          child: SizedBox(
            width: _buttonWidth,
            child: RaisedButton(
              elevation: 6,
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(snapshot.data['index'] == index ? iconPressed:icon, height: 25, width: 25),
                    Text(
                      buttonText,
                      style: TextStyle(fontSize: 12, color: snapshot.data['index'] == index ? Colors.white : Colors.black),
                    )
              ]),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0),),
              color: snapshot.data['index'] == index ? Theme.of(context).accentColor : Colors.white,
              onPressed: (){
                if(!buttonText.contains("전화")){
                  mainButtonController.updateMainButtonIndex({"index": index, "expanded": false});
                  chatController.setChatList(ChatMessage(chat: Text(msgText, style: Theme.of(context).textTheme.bodyText2)));
                  headerImageController.setHeaderImage(logoPath);
                } else{
                  showMaterialModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      builder: (context, scrollController) => TelephoneSheets(Container()));
                }
              },
            ),
          ),
        );
      }
    );
  }

  Widget _settingButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: SizedBox(
        width: 70,
        child: RaisedButton(
          elevation: 6,
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
          child: Text(
            "설정",
            style: TextStyle(fontSize: 12, color: Colors.black),
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0),),
          color: Colors.white,
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (_) => SettingScreen()));
          },
        ),
      ),
    );
  }
}