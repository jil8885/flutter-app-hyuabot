import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_hyuabot_v2/Config/AdManager.dart';
import 'package:flutter_app_hyuabot_v2/Config/GlobalVars.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sqflite/sqflite.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
const MethodChannel readingRoomChannel = MethodChannel('kobuggi.app/reading_room_notification');
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject = BehaviorSubject<ReceivedNotification>();
final BehaviorSubject<String> selectNotificationSubject = BehaviorSubject<String>();
NotificationAppLaunchDetails notificationAppLaunchDetails;

void initApp() async {
  final String srcPath = join("assets/databases", "information.db");
  final String destPath = join(await getDatabasesPath(), "information.db");

  ByteData srcData = await rootBundle.load(srcPath);
  await Directory(dirname(destPath)).create(recursive: true);
  ByteData destData;
  try{
    destData = await rootBundle.load(destPath);
    if(srcData.lengthInBytes != destData.lengthInBytes){
      await deleteDatabase(destPath);
      List<int> bytes = srcData.buffer.asUint8List(srcData.offsetInBytes, srcData.lengthInBytes);
      await new File(destPath).writeAsBytes(bytes, flush: true);
    }
  } catch(_){
    await deleteDatabase(destPath);
    List<int> bytes = srcData.buffer.asUint8List(srcData.offsetInBytes, srcData.lengthInBytes);
    await new File(destPath).writeAsBytes(bytes, flush: true);
  }
  // Ad
  adController.setTestDeviceIds(["F99695B64D31FD9A46D8AB9319E12EA6"]);
  adController.reloadAd(forceRefresh: true, numberAds: 5);
  adController.setAdUnitID(AdManager.bannerAdUnitId);

  // FCM
  fcmManager = FirebaseMessaging();

  // Alarm
  notificationAppLaunchDetails = await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  const AndroidInitializationSettings _initialSettingsAndroid = AndroidInitializationSettings('@mipmap/launcher_icon');
  const InitializationSettings _settings = InitializationSettings(android: _initialSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(_settings,
      onSelectNotification: whenSelectNotification);
}

Future whenSelectNotification(String payload) async{
  debugPrint(payload);
  prefManager.setBool(payload, false);
  fcmManager.unsubscribeFromTopic("$payload.ko_KR");
  fcmManager.unsubscribeFromTopic("$payload.en_US");
  fcmManager.unsubscribeFromTopic("$payload.zh");
  readingRoomController.fetchAlarm();
  selectNotificationSubject.add(payload);
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Widget _logoImage = Image.asset('assets/images/hanyang-phone.png');

  @override
  void initState() {
    initApp();
    super.initState();
    startTime();
  }

  startTime() async {
    var _duration = new Duration(seconds: 1);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Get.offAllNamed('/HomeScreen');
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

class ReceivedNotification {
  ReceivedNotification({
    @required this.id,
    @required this.title,
    @required this.body,
    @required this.payload,
  });

  final int id;
  final String title;
  final String body;
  final String payload;
}
