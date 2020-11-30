import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter_app_hyuabot_v2/Bloc/BusController.dart';
import 'package:flutter_app_hyuabot_v2/Bloc/MetroController.dart';
import 'package:flutter_app_hyuabot_v2/Bloc/ShuttleController.dart';
import 'package:flutter_app_hyuabot_v2/Model/FoodMenu.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';

AdaptiveThemeMode savedThemeMode;

// Controllers
final busController = FetchBusInfoController();
final shuttleController = FetchAllShuttleController();
final metroController = FetchMetroInfoController();

// Ad manager
final adController = NativeAdmobController();

// food info
Map<String, Map<String, List<FoodMenu>>> allMenus = {};