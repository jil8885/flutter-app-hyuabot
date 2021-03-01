import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_app_hyuabot_v2/Config/AdManager.dart';
import 'package:flutter_app_hyuabot_v2/Config/GlobalVars.dart';
import 'package:flutter_app_hyuabot_v2/Model/ReadingRoom.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_options.dart';

class ReadingRoomPage extends StatelessWidget {

  Widget _readingRoomCard(BuildContext context, String name, TextStyle theme) {
    String _alarmOnString;
    String _alarmOffString;

    switch(prefManager.getString("localeCode")){
      case "ko_KR":
        _alarmOnString = "${name.tr()}의 좌석 알림이 설정되었다냥!";
        _alarmOffString = "${name.tr()}의 좌석 알림이 해제되었다냥!";
        break;
      case "en_US":
        _alarmOnString = "Alarm on for ${name.tr()}";
        _alarmOffString = "Alarm off for ${name.tr()}";
        break;
      case "zh":
        _alarmOnString = "${name.tr()}의 좌석 알림이 설정되었다냥!";
        _alarmOffString = "${name.tr()}의 좌석 알림이 해제되었다냥!";
        break;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Card(
        elevation: 3,
        color: theme.color,
        child: Container(
          height: 80,
          child: StreamBuilder<Map<String, dynamic>>(
            stream: readingRoomController.currentData,
            builder: (context, snapshot) {
              if(snapshot.hasError || !snapshot.hasData){
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(name.tr(), style: TextStyle(color: Theme.of(context).backgroundColor == Colors.white ? Colors.black : Colors.white, fontSize: 24), textAlign: TextAlign.center,),
                    Text.rich(TextSpan(children: [
                      TextSpan(text: "-", style: TextStyle(color: Theme.of(context).backgroundColor == Colors.white ? Colors.black : Colors.white, fontSize: 22)),
                      TextSpan(text: '/-', style: TextStyle(color: Colors.grey, fontSize: 22)),
                    ])),
                    IconButton(icon: Icon(Icons.alarm_off_rounded, color: Theme.of(context).backgroundColor == Colors.white ? Colors.black : Colors.white,), onPressed: (){}),
                  ],
                );
              }
              ReadingRoomInfo seats = snapshot.data["seats"][name];
              bool alarmActive = snapshot.data["alarm"][name];
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(name.tr(), style: TextStyle(color: Theme.of(context).backgroundColor == Colors.white ? Colors.black : Colors.white, fontSize: 24), textAlign: TextAlign.center,),
                  Text.rich(TextSpan(children: [
                    TextSpan(text: seats.available.toString(), style: TextStyle(color: Theme.of(context).backgroundColor == Colors.white ? Colors.black : Colors.white, fontSize: 22)),
                    TextSpan(text: '/${seats.active}', style: TextStyle(color: Colors.grey, fontSize: 22)),
                  ])),
                  IconButton(icon: Icon(alarmActive ? Icons.alarm_on_rounded:Icons.alarm_off_rounded, color: Theme.of(context).backgroundColor == Colors.white ? Colors.black : Colors.white,), onPressed: (){
                    if(alarmActive){
                      fcmManager.unsubscribeFromTopic("$name.ko_KR");
                      fcmManager.unsubscribeFromTopic("$name.en_US");
                      fcmManager.unsubscribeFromTopic("$name.zh");
                      prefManager.setBool(name, false);
                      readingRoomController.updateAlarm();
                      Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text(_alarmOffString, style: TextStyle(color:Theme.of(context).backgroundColor == Colors.black ? Colors.white:Colors.black), textAlign: TextAlign.center,),
                          backgroundColor: Theme.of(context).backgroundColor,
                          duration: Duration(seconds: 2),
                      ));
                    } else {
                      if(seats.available < (kReleaseMode?0:100)){
                        fcmManager.subscribeToTopic("$name.${prefManager.getString("localeCode")}");
                        prefManager.setBool(name, true);
                        readingRoomController.updateAlarm();
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text(_alarmOnString, style: TextStyle(color:Theme.of(context).backgroundColor == Colors.black ? Colors.white:Colors.black), textAlign: TextAlign.center,),
                          backgroundColor: Theme.of(context).backgroundColor,
                          duration: Duration(seconds: 2),
                        ));
                      } else{
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text("seat_remained_error".tr(), style: TextStyle(color:Theme.of(context).backgroundColor == Colors.black ? Colors.white:Colors.black), textAlign: TextAlign.center,),
                          backgroundColor: Theme.of(context).backgroundColor,
                          duration: Duration(seconds: 2),
                        ));
                      }
                    }
                  }),
                ],
              );
            }
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double _statusBarHeight = MediaQuery.of(context).padding.top;
    final TextStyle _theme = Theme.of(context).textTheme.bodyText1;

    analytics.setCurrentScreen(screenName: "/library");
    if(prefManager.getBool("reading_room_1") == null || prefManager.getBool("reading_room_2") == null || prefManager.getBool("reading_room_3") == null || prefManager.getBool("reading_room_4") == null){
      prefManager.setBool("reading_room_1", false);
      prefManager.setBool("reading_room_2", false);
      prefManager.setBool("reading_room_3", false);
      prefManager.setBool("reading_room_4", false);
    }

    return Scaffold(
      body: Container(
            padding: EdgeInsets.only(top: _statusBarHeight),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(icon: Icon(Icons.arrow_back_rounded, color: Theme.of(context).textTheme.bodyText2.color,), onPressed: (){Navigator.of(context).pop();}, padding: EdgeInsets.only(left: 20), alignment: Alignment.centerLeft,)
                    ],
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            height: 450,
                            child: ListView(
                              physics: BouncingScrollPhysics(),
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              children: [
                                _readingRoomCard(context, "reading_room_1",  _theme),
                                _readingRoomCard(context, "reading_room_2",  _theme),
                                _readingRoomCard(context, "reading_room_3", _theme),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [Center(child: Text("how_use_library_page".tr(), textAlign: TextAlign.center, style: TextStyle(color: Colors.grey),),)],
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
                      error: Center(child: Text('plz_enable_ad'.tr(), style: TextStyle(color: Theme.of(context).textTheme.bodyText2.color, fontSize: 14), textAlign: TextAlign.center,)),
                      options: NativeAdmobOptions(
                        adLabelTextStyle: NativeTextStyle(color: Theme.of(context).textTheme.bodyText2.color,),
                        bodyTextStyle: NativeTextStyle(color: Theme.of(context).textTheme.bodyText2.color),
                        headlineTextStyle: NativeTextStyle(color: Theme.of(context).textTheme.bodyText2.color),
                        advertiserTextStyle: NativeTextStyle(color: Theme.of(context).textTheme.bodyText2.color),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
    );
  }
}
