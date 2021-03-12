import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
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
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:flutter_native_admob/native_admob_options.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';

import 'AdManager.dart';

// Ad manager
final adController = NativeAdmobController();
getAdWidget(BuildContext context){
  return Container(
    height: 90,
    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
    child: NativeAdmob(
      adUnitID: AdManager.bannerAdUnitId,
      numberAds: 1,
      controller: adController,
      type: NativeAdmobType.banner,
      error: Center(
          child: Text(
            "plz_enable_ad".tr(),
            style: TextStyle(color: Theme.of(context).textTheme.bodyText2!.color, fontSize: 14),
            textAlign: TextAlign.center,
          )),
      options: NativeAdmobOptions(
        adLabelTextStyle: NativeTextStyle(color: Theme.of(context).textTheme.bodyText2!.color,),
        bodyTextStyle: NativeTextStyle(color: Theme.of(context).textTheme.bodyText2!.color),
        headlineTextStyle: NativeTextStyle(color: Theme.of(context).textTheme.bodyText2!.color),
        advertiserTextStyle: NativeTextStyle(color: Theme.of(context).textTheme.bodyText2!.color),
      ),
    ),
  );
}

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