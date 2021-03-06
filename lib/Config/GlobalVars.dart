import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_hyuabot_v2/Bloc/BusController.dart';
import 'package:flutter_app_hyuabot_v2/Bloc/DateController.dart';
import 'package:flutter_app_hyuabot_v2/Bloc/FoodController.dart';
import 'package:flutter_app_hyuabot_v2/Bloc/MetroController.dart';
import 'package:flutter_app_hyuabot_v2/Bloc/NotificationController.dart';
import 'package:flutter_app_hyuabot_v2/Bloc/PhoneSearchController.dart';
import 'package:flutter_app_hyuabot_v2/Bloc/ReadingRoomController.dart';
import 'package:flutter_app_hyuabot_v2/Bloc/ShuttleController.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Ad manager
final adController = NativeAdmobController();

// FCM Manager
FirebaseMessaging? fcmManager;

// Notification
class ReceivedNotification {
  ReceivedNotification(
    this.id,
    this.title,
    this.body,
    this.payload,
  );

  final int id;
  final String title;
  final String body;
  final String payload;
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
const MethodChannel readingRoomChannel = MethodChannel('kobuggi.app/reading_room_notification');
NotificationAppLaunchDetails? notificationAppLaunchDetails;
// final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject = BehaviorSubject<ReceivedNotification>();
final selectNotificationSubject = NotificationController();


// PrefManager
SharedPreferences? prefManager;

// Theme
AdaptiveThemeMode? savedThemeMode;

// Controllers
final BusDepartureController busDepartureController = BusDepartureController();
final BusTimetableController busTimetableController = BusTimetableController();
final DateController dateController = DateController();
final FoodInfoController foodInfoController = FoodInfoController();
final FetchMetroInfoController metroInfoController = FetchMetroInfoController();
final NotificationController notificationController = NotificationController();
final InSchoolPhoneSearchController inSchoolPhoneSearchController = InSchoolPhoneSearchController();
final OutSchoolPhoneSearchController outSchoolPhoneSearchController = OutSchoolPhoneSearchController();
final ReadingRoomController readingRoomController = ReadingRoomController();
final ShuttleDepartureController shuttleDepartureController = ShuttleDepartureController();
final ShuttleTimeTableController shuttleTimeTableController = ShuttleTimeTableController();