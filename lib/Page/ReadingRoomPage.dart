import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app_hyuabot_v2/Bloc/ReadingRoomController.dart';
import 'package:flutter_app_hyuabot_v2/Config/AdManager.dart';
import 'package:flutter_app_hyuabot_v2/Config/GlobalVars.dart';
import 'package:flutter_app_hyuabot_v2/Model/ReadingRoom.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_options.dart';
import 'package:get/get.dart';

class ReadingRoomPage extends StatelessWidget {
  Widget _readingRoomCard(String name, int active, int available, TextStyle theme, bool alarmActive) {
    String _alarmOnString;
    String _alarmOffString;

    switch(prefManager.read("localeCode")){
      case "ko_KR":
        _alarmOnString = "${name.tr}의 좌석 알림이 설정되었다냥!";
        _alarmOffString = "${name.tr}의 좌석 알림이 해제되었다냥!";
        break;
      case "en_US":
        _alarmOnString = "Alarm on for ${name.tr}";
        _alarmOffString = "Alarm off for ${name.tr}";
        break;
      case "zh":
        _alarmOnString = "${name.tr}의 좌석 알림이 설정되었다냥!";
        _alarmOffString = "${name.tr}의 좌석 알림이 해제되었다냥!";
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
              Text(name.tr, style: TextStyle(color: !Get.isDarkMode ? Colors.black : Colors.white, fontSize: 24), textAlign: TextAlign.center,),
              Text.rich(TextSpan(children: [
                TextSpan(text: available.toString(), style: TextStyle(color: !Get.isDarkMode ? Colors.black : Colors.white, fontSize: 22)),
                TextSpan(text: '/$active', style: TextStyle(color: Colors.grey, fontSize: 22)),
              ])),
              IconButton(icon: Icon(alarmActive ? Icons.alarm_on_rounded:Icons.alarm_off_rounded, color: !Get.isDarkMode ? Colors.black : Colors.white,), onPressed: (){
                if(alarmActive){
                  fcmManager.unsubscribeFromTopic("$name.ko_KR");
                  fcmManager.unsubscribeFromTopic("$name.en_US");
                  fcmManager.unsubscribeFromTopic("$name.zh");
                  prefManager.write(name, false);
                  readingRoomController.fetchAlarm();
                  Get.showSnackbar(GetBar(messageText: Text(_alarmOffString),));
                } else {
                  if(available < 0){
                    fcmManager.subscribeToTopic("$name.${prefManager.read("localeCode")}");
                    prefManager.write(name, true);
                    readingRoomController.fetchAlarm();
                    Get.showSnackbar(GetBar(messageText: Text(_alarmOnString),));
                  } else{
                    Get.showSnackbar(GetBar(messageText: Text("seat_remained_error".tr),));
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
  Widget build(BuildContext context) {
    final double _statusBarHeight = MediaQuery.of(context).padding.top;
    final TextStyle _theme2 = Theme.of(context).textTheme.bodyText2;

    analytics.setCurrentScreen(screenName: "/library");
    if(prefManager.read("reading_room_1") == null || prefManager.read("reading_room_2") == null || prefManager.read("reading_room_3") == null || prefManager.read("reading_room_4") == null){
      prefManager.write("reading_room_1", false);
      prefManager.write("reading_room_2", false);
      prefManager.write("reading_room_3", false);
      prefManager.write("reading_room_4", false);
    }

    return Scaffold(
      body: GetBuilder<ReadingRoomController>(
        builder: (controller) {
          Map<String, ReadingRoomInfo> data = controller.readingRoomData;
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
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            height: 400,
                            child: ListView(
                              physics: BouncingScrollPhysics(),
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              children: [
                                _readingRoomCard("reading_room_1", data["제1열람실"].active, data["제1열람실"].available, _theme2, controller.readingRoomAlarm["reading_room_1"]),
                                _readingRoomCard("reading_room_2", data["제2열람실"].active, data["제2열람실"].available, _theme2, controller.readingRoomAlarm["reading_room_2"]),
                                _readingRoomCard("reading_room_3", data["제3열람실"].active, data["제3열람실"].available, _theme2, controller.readingRoomAlarm["reading_room_3"]),
                                _readingRoomCard("reading_room_4", data["제4열람실"].active, data["제4열람실"].available, _theme2, controller.readingRoomAlarm["reading_room_4"]),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [Center(child: Text("how_use_library_page".tr, textAlign: TextAlign.center, style: TextStyle(color: Colors.grey),),)],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 90,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    child: NativeAdmob(
                      adUnitID: AdManager.bannerAdUnitId,
                      numberAds: 1,
                      controller: adController,
                      type: NativeAdmobType.banner,
                      error: Center(child: Text('plz_enable_ad'.tr, style: TextStyle(color: Theme.of(context).textTheme.bodyText1.color, fontSize: 14), textAlign: TextAlign.center,)),
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
}
