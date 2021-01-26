import 'package:flutter_app_hyuabot_v2/Model/Store.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class PhoneSearchController extends GetxController{
  String _path;
  Database _database;
  List<Map> markers = [];
  List<StoreSearchInfo> searchResult = [];

  PhoneSearchController() {
    getDatabasesPath().then((value){_path = value;});
    openDatabase(
        join(_path, "information.db")
    ).then((value){_database = value;});
  }
}
