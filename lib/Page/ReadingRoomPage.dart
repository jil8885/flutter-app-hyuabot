import 'dart:async';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_hyuabot_v2/Bloc/ReadingRoomController.dart';
import 'package:flutter_app_hyuabot_v2/Config/AdManager.dart';
import 'package:flutter_app_hyuabot_v2/Config/GlobalVars.dart';
import 'package:flutter_app_hyuabot_v2/Model/ReadingRoom.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_options.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class ReadingRoomPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ReadingRoomState();
}

Future<dynamic> backgroundMessageHandler(Map<String, dynamic> message) async {
  print("onBackground: $message");

  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
  }

  // Or do other work.
}

class ReadingRoomState extends State<ReadingRoomPage>{
  ReadingRoomController _readingRoomController;

  // FCM controller
  FirebaseMessaging _fcmController;
  Timer _fetchTimer;


  Widget _readingRoomCard(String name, int active, int available, TextStyle theme, String prefKey) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Card(
        elevation: 3,
        color: theme.color,
        child: Container(
          height: 80,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                children: [
                  SizedBox(width: 30,),
                  Text(name, style: TextStyle(color: Colors.black, fontSize: 24, fontFamily: 'Godo'), textAlign: TextAlign.center,),
                ],
              ),
              Row(
                children: [
                  Text.rich(TextSpan(children: [
                    TextSpan(text: available.toString(), style: TextStyle(color: Colors.black, fontFamily: 'Godo', fontSize: 22)),
                    TextSpan(text: '/$active', style: TextStyle(color: Colors.grey, fontFamily: 'Godo', fontSize: 22)),
                  ])),
                  SizedBox(width: 50,),
                  IconButton(icon: Icon(Icons.alarm_on_rounded, color: Colors.black,), onPressed: (){
                    if(available < 1){
                      setState(() {
                        _fcmController.subscribeToTopic(prefKey);
                        Fluttertoast.showToast(msg: "$name의 좌석 알림이 설정되었다냥!");
                      });
                    } else{
                      Fluttertoast.showToast(msg: "자리가 없을 때만 설정이 가능하다냥!");
                    }
                  }),
                  SizedBox(width: 30,)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }


  @override
  void initState() {
    _fcmController = FirebaseMessaging();
    _fcmController.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
      onBackgroundMessage: backgroundMessageHandler
    );
    _readingRoomController = ReadingRoomController();
    _fetchTimer = Timer.periodic(Duration(minutes: 1), (timer){_readingRoomController.fetch();});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double _statusBarHeight = MediaQuery.of(context).padding.top;
    final TextStyle _theme2 = Theme.of(context).textTheme.bodyText2;

    return Scaffold(
      body: StreamBuilder<Map<String, ReadingRoomInfo>>(
        stream: _readingRoomController.allReadingRoom,
        builder: (context, snapshot) {
          if(snapshot.hasError){
            return Center(child: Text("셔틀 정보를 불러오는데 실패했습니다.", style: Theme.of(context).textTheme.bodyText1,),);
          } else if(!snapshot.hasData){
            return Center(child: CircularProgressIndicator(),);
          }
          return Container(
            padding: EdgeInsets.only(top: _statusBarHeight),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(icon: Icon(Icons.arrow_back_rounded, color: Theme.of(context).textTheme.bodyText1.color,), onPressed: (){Get.back();}, padding: EdgeInsets.only(left: 20), alignment: Alignment.centerLeft,)
                    ],
                  ),
                  Container(
                    height: 400,
                    child: ListView(
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      children: [
                        _readingRoomCard("제1열람실", snapshot.data["제1열람실"].active, snapshot.data["제1열람실"].available, _theme2, "reading_room_1"),
                        _readingRoomCard("제2열람실", snapshot.data["제2열람실"].active, snapshot.data["제2열람실"].available, _theme2, "reading_room_2"),
                        _readingRoomCard("제3열람실", snapshot.data["제3열람실"].active, snapshot.data["제3열람실"].available, _theme2, "reading_room_3"),
                        _readingRoomCard("제4열람실", snapshot.data["제4열람실"].active, snapshot.data["제4열람실"].available, _theme2, "reading_room_4"),
                      ],
                    ),
                  ),
                  Expanded(child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Center(child: Text("열람실 좌석이 없을 때 좌석 알람을 받을 수 있어요!", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey),),)],
                  ),),
                  Container(
                    height: 90,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    child: NativeAdmob(
                      adUnitID: AdManager.bannerAdUnitId,
                      numberAds: 1,
                      controller: adController,
                      type: NativeAdmobType.banner,
                      error: Center(child: Text("광고 불러오기 실패", style: TextStyle(color: Theme.of(context).textTheme.bodyText1.color, fontSize: 14), textAlign: TextAlign.center,)),
                      options: NativeAdmobOptions(
                        adLabelTextStyle: NativeTextStyle(color: Theme.of(context).textTheme.bodyText1.color,),
                        bodyTextStyle: NativeTextStyle(color: Theme.of(context).textTheme.bodyText1.color),
                        headlineTextStyle: NativeTextStyle(color: Theme.of(context).textTheme.bodyText1.color),
                        advertiserTextStyle: NativeTextStyle(color: Theme.of(context).textTheme.bodyText1.color),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      ),
    );
  }

  @override
  void dispose() {
    _fetchTimer.cancel();
    _readingRoomController.dispose();
    super.dispose();
  }
}