import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import 'package:flutter_app_hyuabot_v2/Config/AdManager.dart';
import 'package:flutter_app_hyuabot_v2/Config/GlobalVars.dart';


void initApp() async {
  final String srcPath = path.join("assets/databases", "information.db");
  final String destPath = path.join(await getDatabasesPath(), "information.db");
  final int srcSize = prefManager.getInt("databaseSize") ?? 0;

  ByteData srcData = await rootBundle.load(srcPath);
  await Directory(path.dirname(destPath)).create(recursive: true);
  try{
    if(srcData.lengthInBytes != srcSize){
      await deleteDatabase(destPath);
      List<int> bytes = srcData.buffer.asUint8List(srcData.offsetInBytes, srcData.lengthInBytes);
      await new File(destPath).writeAsBytes(bytes, flush: true);
      prefManager.setInt("databaseSize", srcData.lengthInBytes);
    }
  } catch(_){
    await deleteDatabase(destPath);
    List<int> bytes = srcData.buffer.asUint8List(srcData.offsetInBytes, srcData.lengthInBytes);
    await new File(destPath).writeAsBytes(bytes, flush: true);
  }
  // Ad
  adController.setTestDeviceIds(["9EB3D1FB602993E0660E26FD66A53A25"]);
  adController.reloadAd(forceRefresh: true, numberAds: 3);
  adController.setAdUnitID(AdManager.bannerAdUnitId);

  // Alarm
  notificationAppLaunchDetails = await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  const AndroidInitializationSettings _initialSettingsAndroid = AndroidInitializationSettings('@mipmap/launcher_icon');
  const InitializationSettings _settings = InitializationSettings(android: _initialSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(_settings,
      onSelectNotification: whenSelectNotification);

  // Locale
  if (prefManager.getString("localeCode") == null){
    prefManager.setString("localeCode", "ko_KR");
  }
}

Future whenSelectNotification(String payload) async{
  prefManager.setBool(payload, false);
  fcmManager.unsubscribeFromTopic("$payload.ko_KR");
  fcmManager.unsubscribeFromTopic("$payload.en_US");
  fcmManager.unsubscribeFromTopic("$payload.zh");
  readingRoomController.fetchAlarm();
  selectNotificationSubject.addNotification(payload.tr());
}

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>{
  final Widget _logoImage = Image.asset('assets/images/hanyang-phone.png');

  startTime() async {
    var _duration = new Duration(seconds: 1);
    initApp();
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.of(context).pushReplacementNamed('/home');
  }

  @override
  void initState() {
    startTime();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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


