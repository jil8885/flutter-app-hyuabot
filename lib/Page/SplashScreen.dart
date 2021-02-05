import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_hyuabot_v2/Config/AdManager.dart';
import 'package:flutter_app_hyuabot_v2/Page/HomePage.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:flutter_app_hyuabot_v2/Config/GlobalVars.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


void initApp() async {
  final String srcPath = join("assets/databases", "information.db");
  final String destPath = join(await getDatabasesPath(), "information.db");
  final int srcSize = prefManager.read("databaseSize") ?? 0;

  ByteData srcData = await rootBundle.load(srcPath);
  await Directory(dirname(destPath)).create(recursive: true);
  try{
    if(srcData.lengthInBytes != srcSize){
      await deleteDatabase(destPath);
      List<int> bytes = srcData.buffer.asUint8List(srcData.offsetInBytes, srcData.lengthInBytes);
      await new File(destPath).writeAsBytes(bytes, flush: true);
      prefManager.write("databaseSize", srcData.lengthInBytes);
    }
  } catch(_){
    await deleteDatabase(destPath);
    List<int> bytes = srcData.buffer.asUint8List(srcData.offsetInBytes, srcData.lengthInBytes);
    await new File(destPath).writeAsBytes(bytes, flush: true);
  }
  // Ad
  adController.setTestDeviceIds(["F99695B64D31FD9A46D8AB9319E12EA6"]);
  adController.reloadAd(forceRefresh: true, numberAds: 3);
  adController.setAdUnitID(AdManager.bannerAdUnitId);

  // Alarm
  notificationAppLaunchDetails = await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  const AndroidInitializationSettings _initialSettingsAndroid = AndroidInitializationSettings('@mipmap/launcher_icon');
  const InitializationSettings _settings = InitializationSettings(android: _initialSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(_settings,
      onSelectNotification: whenSelectNotification);
}

Future whenSelectNotification(String payload) async{
  prefManager.write(payload, false);
  fcmManager.unsubscribeFromTopic("$payload.ko_KR");
  fcmManager.unsubscribeFromTopic("$payload.en_US");
  fcmManager.unsubscribeFromTopic("$payload.zh");
  readingRoomController.fetchAlarm();
  selectNotificationSubject.addNotification(payload.tr);
}

class SplashScreen extends StatelessWidget {
  final Widget _logoImage = Image.asset('assets/images/hanyang-phone.png');

  startTime() async {
    var _duration = new Duration(seconds: 1);
    initApp();
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Get.offAll(HomePage());
  }

  @override
  Widget build(BuildContext context) {
    startTime();
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body:  Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          _logoImage,
        ],
      ),
    );
  }
}


