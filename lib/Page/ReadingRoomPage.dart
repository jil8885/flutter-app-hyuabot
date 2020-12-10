import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_hyuabot_v2/Config/AdManager.dart';
import 'package:flutter_app_hyuabot_v2/Config/GlobalVars.dart';
import 'package:flutter_app_hyuabot_v2/Model/ReadingRoom.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_options.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class ReadingRoomPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ReadingRoomState();
}

class ReadingRoomState extends State<ReadingRoomPage>{
  // FCM controller
  FirebaseMessaging _fcmController;
  FirebaseFirestore _firestore;
  CollectionReference query;
  final ReadingRoomStatus readingRoomStatus = ReadingRoomStatus(prefManager);


  Widget _readingRoomCard(String name, int active, int available, TextStyle theme, bool alarmActive, String prefKey) {
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
                  Text(name, style: TextStyle(color: Theme.of(context).backgroundColor == Colors.white ? Colors.black : Colors.white, fontSize: 24, fontFamily: 'Godo'), textAlign: TextAlign.center,),
                ],
              ),
              Row(
                children: [
                  Text.rich(TextSpan(children: [
                    TextSpan(text: available.toString(), style: TextStyle(color: Theme.of(context).backgroundColor == Colors.white ? Colors.black : Colors.white, fontFamily: 'Godo', fontSize: 22)),
                    TextSpan(text: '/$active', style: TextStyle(color: Colors.grey, fontFamily: 'Godo', fontSize: 22)),
                  ])),
                  SizedBox(width: 50,),
                  IconButton(icon: Icon(alarmActive ? Icons.alarm_on_rounded:Icons.alarm_off_rounded, color: Theme.of(context).backgroundColor == Colors.white ? Colors.black : Colors.white,), onPressed: (){
                    if(alarmActive){
                      _fcmController.unsubscribeFromTopic(prefKey);
                      prefManager.setBool(prefKey, false);
                      Fluttertoast.showToast(msg: "$name의 좌석 알림이 해제되었다냥!");
                      setState(() {});
                    } else {
                      if(available < 1){
                          _fcmController.subscribeToTopic(prefKey);
                          prefManager.setBool(prefKey, true);
                          Fluttertoast.showToast(msg: "$name의 좌석 알림이 설정되었다냥!");
                          setState(() {});
                      } else{
                        Fluttertoast.showToast(msg: "자리가 없을 때만 설정이 가능하다냥!");
                      }
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
    _firestore = FirebaseFirestore.instance;
    query = _firestore.collection('reading_room').doc('erica').collection('rooms');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double _statusBarHeight = MediaQuery.of(context).padding.top;
    final TextStyle _theme2 = Theme.of(context).textTheme.bodyText2;

    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: query.snapshots(),
        builder: (context, stream) {
          // if (stream.connectionState == ConnectionState.waiting) {
          //   return Center(child: CircularProgressIndicator());
          // }
          if (stream.hasError) {
            return Center(child: Text("열람실 정보를 불러오는데 실패했습니다.", style: Theme.of(context).textTheme.bodyText1,),);
          }
          if(!stream.hasData){
            return Center(child: CircularProgressIndicator(),);
          }
          QuerySnapshot snapshot = stream.data;
          Map<String, ReadingRoomInfo> data = {};
          for(QueryDocumentSnapshot doc in snapshot.docs){
            Map<String, dynamic> docData  = doc.data();
            data[docData['name']] = ReadingRoomInfo.fromJson(docData);
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
                        PreferenceBuilder(preference: readingRoomStatus.readingRoom1, builder: (context, alarmActive) => _readingRoomCard("제1열람실", data["제1열람실"].active, data["제1열람실"].available, _theme2, alarmActive, "reading_room_1")),
                        PreferenceBuilder(preference: readingRoomStatus.readingRoom2, builder: (context, alarmActive) => _readingRoomCard("제2열람실", data["제2열람실"].active, data["제2열람실"].available, _theme2, alarmActive, "reading_room_2")),
                        PreferenceBuilder(preference: readingRoomStatus.readingRoom3, builder: (context, alarmActive) => _readingRoomCard("제3열람실", data["제3열람실"].active, data["제3열람실"].available, _theme2, alarmActive, "reading_room_3")),
                        PreferenceBuilder(preference: readingRoomStatus.readingRoom4, builder: (context, alarmActive) => _readingRoomCard("제4열람실", data["제4열람실"].active, data["제4열람실"].available, _theme2, alarmActive, "reading_room_4")),
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
    _firestore.terminate();
    super.dispose();
  }
}

class ReadingRoomStatus{
  ReadingRoomStatus(StreamingSharedPreferences preferences)
      : readingRoom1 = prefManager.getBool('reading_room_1', defaultValue: false),
        readingRoom2 = prefManager.getBool('reading_room_2', defaultValue: false),
        readingRoom3 = prefManager.getBool('reading_room_3', defaultValue: false),
        readingRoom4 = prefManager.getBool('reading_room_4', defaultValue: false);

  final Preference<bool> readingRoom1;
  final Preference<bool> readingRoom2;
  final Preference<bool> readingRoom3;
  final Preference<bool> readingRoom4;

}