import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

AdaptiveThemeMode savedThemeMode;
// Ad manager
final adController = NativeAdmobController();

StreamingSharedPreferences prefManager;


