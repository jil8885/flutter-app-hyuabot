import 'dart:async';

import 'package:chatbot/bloc/PhoneSearchController.dart';
import 'package:chatbot/config/Common.dart';
import 'package:chatbot/config/Localization.dart';
import 'package:chatbot/main.dart';
import 'package:chatbot/model/ReadingRoom.dart';
import 'package:chatbot/pages/HomeScreen.dart';
import 'package:chatbot/pages/SettingScreen.dart';
import 'package:chatbot/ui/bottom_sheet/LibrarySheets.dart';
import 'package:chatbot/ui/bottom_sheet/TelephoneSheets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

import '../ChatMessage.dart';

class MainMenuButtons extends StatefulWidget {
  final HomeScreenStates homePage;
  final double padding;

  MainMenuButtons(this.homePage, this.padding);
  @override
  State<StatefulWidget> createState() => MainButtonState(homePage, padding);
}

class MainButtonState extends State<MainMenuButtons>{
  HomeScreenStates homePage;
  double padding;

  MainButtonState(this.homePage, this.padding);
  @override
  Widget build(BuildContext context) {
      Widget mainButton = Padding(padding: EdgeInsets.symmetric(horizontal: padding),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(children: [
                    _makeFuncButton(context, Translations.of(context).trans("select_transport_msg"), getImagePath(context, "header-bus.png"), "assets/images/shared/icon-bus.png", "assets/images/shared/icon-bus-active.png", Translations.of(context).trans("transport_btn"), 0),
                    _makeFuncButton(context, Translations.of(context).trans("select_cafeteria_msg"), getImagePath(context, "header-food.png"), "assets/images/shared/icon-food.png", "assets/images/shared/icon-food-active.png", Translations.of(context).trans("food_btn"), 1),
                    _makeFuncButton(context, "알고 싶은 정보를 골라달라냥!", getImagePath(context, "header-book.png"), "assets/images/shared/icon-book.png", "assets/images/shared/icon-book-active.png", Translations.of(context).trans("reading_room_btn"), 2),
                    _makeFuncButton(context, "밑에서 원하는 기관을 검색하라냥!", getImagePath(context, "header-default.png"), "assets/images/shared/icon-phone.png", "assets/images/shared/icon-phone-active.png", Translations.of(context).trans("contact_btn"), 3),
                  ],),
                ),
              ),
              IconButton(icon: Icon(Icons.keyboard_arrow_up, color: Theme.of(context).backgroundColor == Colors.black? Colors.white : Colors.black,), onPressed: (){
                mainButtonController.updateMainButtonExpand(expand: true);
                this.homePage.setState(() {});
              })
            ],
          )
      );

    Widget mainButtonExpanded =  Padding(
        padding: EdgeInsets.symmetric(horizontal: padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                  _settingButtons(context)
              ],
            ),
            Row(
              children: [
                Expanded(child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(children: [
                  _makeFuncButton(context, Translations.of(context).trans("select_transport_msg"), getImagePath(context, "header-bus.png"), "assets/images/shared/icon-bus.png", "assets/images/shared/icon-bus-active.png", Translations.of(context).trans("transport_btn"), 0),
                  _makeFuncButton(context, Translations.of(context).trans("select_cafeteria_msg"), getImagePath(context, "header-food.png"), "assets/images/shared/icon-food.png", "assets/images/shared/icon-food-active.png", Translations.of(context).trans("food_btn"), 1),
                  _makeFuncButton(context, "알고 싶은 정보를 골라달라냥!", getImagePath(context, "header-book.png"), "assets/images/shared/icon-book.png", "assets/images/shared/icon-book-active.png", Translations.of(context).trans("reading_room_btn"), 2),
                  _makeFuncButton(context, "밑에서 원하는 기관을 검색하라냥!", getImagePath(context, "header-default.png"), "assets/images/shared/icon-phone.png", "assets/images/shared/icon-phone-active.png", Translations.of(context).trans("contact_btn"), 3),
                ],),)),
                IconButton(icon: Icon(Icons.keyboard_arrow_down, color: Theme.of(context).backgroundColor == Colors.black? Colors.white : Colors.black,), onPressed: (){
                  mainButtonController.updateMainButtonExpand(expand: false);
                  this.homePage.setState(() {});
                })
              ],
            )
          ],
        )
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
    return StreamBuilder<Map<String, dynamic>>(
      stream: mainButtonController.mainButtonIndex,
      builder: (context, snapshot) {
        if(!snapshot.hasData){
          return Container();
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 8),
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
              if(timer != null){
                timer.cancel();
              }
              if(index == 3){
                phoneSearcher.fetch();
                showMaterialModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (context, scrollController) {
                      return AnimatedPadding(padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom), duration: Duration(milliseconds: 250),
                        child: TelephoneSheets(
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(children: [
                                TextField(
                                  decoration: InputDecoration(
                                        contentPadding: EdgeInsets.all(8),
                                        suffixIcon: Icon(Icons.search, color: Colors.white,),
                                        labelText: "검색어를 입력해주세요",
                                        labelStyle: TextStyle(color: Colors.white),
                                        hintText: "검색어",
                                        hintStyle: TextStyle(color: Colors.grey[300]),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.white),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.white),
                                        ),
                                  ),
                                  cursorColor: Colors.white,
                                  onChanged: (text){
                                    phoneSearcher.fetch("select * from telephone where name like \'%$text%\'");
                                  },
                                ),
                                StreamBuilder<List<PhoneNum>>(
                                  stream: phoneSearcher.allPhoneInfo,
                                  builder: (context, snapshot) {
                                  if(!snapshot.hasData){
                                    return Container();
                                  }
                                  List<PhoneNum> data = snapshot.data;
                                  return Expanded(
                                    child: ListView.separated(
                                      padding: const EdgeInsets.all(2),
                                        shrinkWrap: true,
                                        itemCount: data.length,
                                        itemBuilder: (BuildContext context, int index){
                                        return GestureDetector(
                                          onTap: (){UrlLauncher.launch("tel://${data[index].number}");},
                                          child: Container(
                                              height: 30,
                                              child: Row(children: [
                                                Flexible(child: Text(data[index].name, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white),)),
                                                Text(data[index].number, style: TextStyle(color: Colors.white))
                                              ],
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,)),
                                        );
                                        },
                                        separatorBuilder: (context, index){
                                        return Divider(color: Theme.of(context).textTheme.bodyText1.color,);
                                        },
                                    ),
                                  );
                                })
                              ],),
                            )
                        )
                      );
                  }
                );
              } else if(index == 2){
                showMaterialModalBottomSheet(context: context, backgroundColor: Colors.transparent, builder: (context, scrollController) => LibrarySheets(_readingRoomSheets(context)));
              } else{
                mainButtonController.updateMainButtonIndex({"index": index, "expanded": false});
                chatController.setChatList(ChatMessage(chat: Text(msgText, style: Theme.of(context).textTheme.bodyText2)));
                headerImageController.setHeaderImage(logoPath);
              }
            },
          ),
        );
      }
    );
  }

  Widget _settingButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      child: RaisedButton(
        elevation: 6,
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
        child: Text(
          Translations.of(context).trans("setting_btn"),
          style: TextStyle(fontSize: 12, color: Colors.black),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0),),
        color: Colors.white,
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (_) => SettingScreen()));
        },
      ),
    );
  }


  Widget _readingRoomSheets(BuildContext context) {
    timer = Timer.periodic(Duration(seconds: 120), (timer) {
      readingRoomController.fetch();
    });

    Map<String, String> rooms = {"제1열람실": "room_1", "제2열람실": "room_2", "제3열람실": "room_3", "제4열람실": "room_4"};
    return StreamBuilder<Map<String, ReadingRoomInfo>>(
        stream: readingRoomController.allReadingRoom,
        builder: (context, snapshot) {
          if (snapshot.hasError || !snapshot.hasData) {
            return CircularProgressIndicator();
          }
          else {
            List<String> names = [];
            for (String name in snapshot.data.keys) {
              if (snapshot.data[name].active != 0) {
                names.add(name);
              }
              names.sort();
            }
            return ListView.separated(
                padding: const EdgeInsets.all(8),
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    height: 10,
                  );
                },
                itemCount: names.length,
                itemBuilder: (_, index) {
                  var isSubscribed = prefs.getBool("${rooms[names[index]]}_${prefs.getString('localeCode')}");
                  if(isSubscribed == null){
                    isSubscribed = false;
                  }
                  print("${rooms[names[index]]}_${prefs.getString('localeCode')}=$isSubscribed");
                  return Container(
                    height: 75,
                    padding: EdgeInsets.only(top: 20, left: 10, right: 20),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            names[index], style: TextStyle(color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),),
                        ),
                        Flexible(child: LinearPercentIndicator(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width - 200,
                          animation: true,
                          lineHeight: 20.0,
                          animationDuration: 1500,
                          percent: snapshot.data[names[index]].available /
                              snapshot.data[names[index]].active,
                          center: Text("${snapshot.data[names[index]]
                              .available}/${snapshot.data[names[index]]
                              .active}", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                          linearStrokeCap: LinearStrokeCap.roundAll,
                          backgroundColor: Colors.white,
                          progressColor: Colors.lightGreen,
                        ),),
                        IconButton(icon: isSubscribed ? Icon(Icons.alarm, color: Colors.white):Icon(Icons.alarm, color: Colors.grey), onPressed: (){
                          if(isSubscribed){
                            prefs.setBool("${rooms[names[index]]}_${prefs.getString('localeCode')}", false);
                            fcm.unsubscribeFromTopic("${rooms[names[index]]}_${prefs.getString('localeCode')}");
                          } else{
                            if(snapshot.data[names[index]].available > 0){
                              Fluttertoast.showToast(msg: "열람실 좌석이 없을 때만 이용할 수 있다냥!");
                            } else{
                              prefs.setBool("${rooms[names[index]]}_${prefs.getString('localeCode')}", true);
                              fcm.subscribeToTopic("${rooms[names[index]]}_${prefs.getString('localeCode')}");
                              Fluttertoast.showToast(msg: "${names[index]}의 좌석 알람을 신청했다냥!");
                            }
                          }
                          readingRoomController.refresh();
                        })
                        // Text("${snapshot.data[names[index]].available}/${snapshot.data[names[index]].active}", style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),),
                      ],
                    ),
                  );
                }
            );
          }
        }
    );
  }
}