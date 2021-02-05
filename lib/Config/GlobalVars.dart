import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_hyuabot_v2/Bloc/NotificationController.dart';
import 'package:flutter_app_hyuabot_v2/Bloc/ReadingRoomController.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:get_storage/get_storage.dart';

// Ad manager
final adController = NativeAdmobController();
final ReadingRoomController readingRoomController = ReadingRoomController();

// FCM Manager
FirebaseMessaging fcmManager;

// Firebase FirebaseAnalytics
FirebaseAnalytics analytics;

// Notification
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

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
const MethodChannel readingRoomChannel = MethodChannel('kobuggi.app/reading_room_notification');
NotificationAppLaunchDetails notificationAppLaunchDetails;
// final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject = BehaviorSubject<ReceivedNotification>();
final selectNotificationSubject = NotificationController();


// PrefManager
final prefManager = GetStorage();