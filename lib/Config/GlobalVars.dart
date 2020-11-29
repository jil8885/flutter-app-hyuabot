import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter_app_hyuabot_v2/Bloc/BusController.dart';
import 'package:flutter_app_hyuabot_v2/Bloc/MetroController.dart';
import 'package:flutter_app_hyuabot_v2/Bloc/ShuttleController.dart';

AdaptiveThemeMode savedThemeMode;

// Controllers
final busController = FetchBusInfoController();
final shuttleController = FetchAllShuttleController();
final metroController = FetchMetroInfoController();