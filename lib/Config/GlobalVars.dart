import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_app_hyuabot_v2/Bloc/ReadingRoomController.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';
import 'package:shared_preferences/shared_preferences.dart';

AdaptiveThemeMode savedThemeMode;
// Ad manager
final adController = NativeAdmobController();
final ReadingRoomController readingRoomController = ReadingRoomController();

// FCM Manager
FirebaseMessaging fcmManager;
String localeCode;

SharedPreferences prefManager;

// Map
NaverMapController mapController;