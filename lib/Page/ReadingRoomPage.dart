import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app_hyuabot_v2/Bloc/ReadingRoomController.dart';
import 'package:flutter_app_hyuabot_v2/Config/AdManager.dart';
import 'package:flutter_app_hyuabot_v2/Config/GlobalVars.dart';
import 'package:flutter_app_hyuabot_v2/Config/Localization.dart';
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
  final ReadingRoomController _controller = ReadingRoomController();
  final ReadingRoomStatus readingRoomStatus = ReadingRoomStatus(prefManager);
  Timer _timer;

  Widget _readingRoomCard(String name, int active, int available, TextStyle theme, bool alarmActive) {
    String _alarmOnString;
    String _alarmOffString;

    switch(prefManager.getString("localeCode", defaultValue: "ko_KR").getValue()){
      case "ko_KR":
        _alarmOnString = "${TranslationManager.of(context).trans(name)}의 좌석 알림이 설정되었다냥!";
        _alarmOffString = "${TranslationManager.of(context).trans(name)}의 좌석 알림이 해제되었다냥!";
        break;
      case "en_US":
        _alarmOnString = "Alarm on for ${TranslationManager.of(context).trans(name)}";
        _alarmOffString = "Alarm off for ${TranslationManager.of(context).trans(name)}";
        break;
      case "zh":
        _alarmOnString = "${TranslationManager.of(context).trans(name)}의 좌석 알림이 설정되었다냥!";
        _alarmOffString = "${TranslationManager.of(context).trans(name)}의 좌석 알림이 해제되었다냥!";
        break;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Card(
        elevation: 3,
        color: theme.color,
        child: Container(
          height: 80,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(TranslationManager.of(context).trans(name), style: TextStyle(color: Theme.of(context).backgroundColor == Colors.white ? Colors.black : Colors.white, fontSize: 24), textAlign: TextAlign.center,),
              Text.rich(TextSpan(children: [
                TextSpan(text: available.toString(), style: TextStyle(color: Theme.of(context).backgroundColor == Colors.white ? Colors.black : Colors.white, fontSize: 22)),
                TextSpan(text: '/$active', style: TextStyle(color: Colors.grey, fontSize: 22)),
              ])),
              IconButton(icon: Icon(alarmActive ? Icons.alarm_on_rounded:Icons.alarm_off_rounded, color: Theme.of(context).backgroundColor == Colors.white ? Colors.black : Colors.white,), onPressed: (){
                if(alarmActive){
                  fcmManager.unsubscribeFromTopic(name);
                  prefManager.setBool(name, false);
                  Fluttertoast.showToast(msg: _alarmOffString);
                } else {
                  if(available < 0){
                    fcmManager.subscribeToTopic(name);
                    prefManager.setBool(name, true);
                    Fluttertoast.showToast(msg: _alarmOnString, toastLength: Toast.LENGTH_SHORT);
                  } else{
                    Fluttertoast.showToast(msg: TranslationManager.of(context).trans("seat_remained_error"), toastLength: Toast.LENGTH_SHORT);
                  }
                }
              }),
            ],
          ),
        ),
      ),
    );
  }


  @override
  void initState() {
    _timer = Timer.periodic(Duration(minutes: 1), (timer) {
      _controller.fetch();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double _statusBarHeight = MediaQuery.of(context).padding.top;
    final TextStyle _theme2 = Theme.of(context).textTheme.bodyText2;

    return Scaffold(
      body: StreamBuilder<Map<String, ReadingRoomInfo>>(
        stream: _controller.allReadingRoom,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text(TranslationManager.of(context).trans("fail_to_load_library"), style: Theme.of(context).textTheme.bodyText1,),);
          }
          if(!snapshot.hasData){
            return Center(child: CircularProgressIndicator(),);
          }
          Map<String, ReadingRoomInfo> data = snapshot.data;
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
                        PreferenceBuilder(preference: readingRoomStatus.readingRoom1, builder: (context, alarmActive) => _readingRoomCard("reading_room_1", data["제1열람실"].active, data["제1열람실"].available, _theme2, alarmActive)),
                        PreferenceBuilder(preference: readingRoomStatus.readingRoom2, builder: (context, alarmActive) => _readingRoomCard("reading_room_2", data["제2열람실"].active, data["제2열람실"].available, _theme2, alarmActive)),
                        PreferenceBuilder(preference: readingRoomStatus.readingRoom3, builder: (context, alarmActive) => _readingRoomCard("reading_room_3", data["제3열람실"].active, data["제3열람실"].available, _theme2, alarmActive)),
                        PreferenceBuilder(preference: readingRoomStatus.readingRoom4, builder: (context, alarmActive) => _readingRoomCard("reading_room_4", data["제4열람실"].active, data["제4열람실"].available, _theme2, alarmActive)),
                      ],
                    ),
                  ),
                  Expanded(child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Center(child: Text(TranslationManager.of(context).trans("how_use_library_page"), textAlign: TextAlign.center, style: TextStyle(color: Colors.grey),),)],
                  ),),
                  Container(
                    height: 90,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    child: NativeAdmob(
                      adUnitID: AdManager.bannerAdUnitId,
                      numberAds: 1,
                      controller: adController,
                      type: NativeAdmobType.banner,
                      error: Center(child: Text(TranslationManager.of(context).trans('plz_enable_ad'), style: TextStyle(color: Theme.of(context).textTheme.bodyText1.color, fontSize: 14), textAlign: TextAlign.center,)),
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
    _timer.cancel();
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