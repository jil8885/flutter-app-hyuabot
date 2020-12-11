import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

AdaptiveThemeMode savedThemeMode;
// Ad manager
final adController = NativeAdmobController();

// FCM Manager
FirebaseMessaging fcmManager;

StreamingSharedPreferences prefManager;


