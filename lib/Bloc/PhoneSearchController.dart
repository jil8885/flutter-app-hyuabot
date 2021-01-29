import 'package:flutter_app_hyuabot_v2/Model/Phone.dart';
import 'package:flutter_app_hyuabot_v2/Model/Store.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class InSchoolPhoneSearchController extends GetxController{
  Database _database;
  RxList<PhoneNum> searchResult = List<PhoneNum>().obs;
  var isLoading = true.obs;

  @override
  onInit(){
    loadDatabase();
    super.onInit();
  }

  loadDatabase() {
    String _path;
    getDatabasesPath().then((value){_path = value;}).whenComplete((){
      openDatabase(
          join(_path, "information.db")
      ).then((value){_database = value;}).whenComplete((){
        search('');
      });
    });
  }

  search(String keyword) async {
    isLoading(true);
    refresh();
    String _query;
    if(keyword.isEmpty){
      _query = "select name, phone from inschool where phone is not null";
    } else {
      _query = "select name, phone from inschool where phone is not null and name like '%$keyword%'";
    }
    List<Map> queryResult = await _database.rawQuery(_query);
    searchResult.assignAll(queryResult.map((e) => PhoneNum.fromJson(e)).toList());
    isLoading(false);
    refresh();
  }
}

class OutSchoolPhoneSearchController extends GetxController{
  Database _database;
  RxList<PhoneNum> searchResult = List<PhoneNum>().obs;
  var isLoading = true.obs;

  @override
  onInit(){
    loadDatabase();
    super.onInit();
  }

  loadDatabase() {
    String _path;
    getDatabasesPath().then((value){_path = value;}).whenComplete((){
      openDatabase(
          join(_path, "information.db")
      ).then((value){_database = value;}).whenComplete((){
        search('');
      });
    });
  }

  search(String keyword) async {
    isLoading(true);
    refresh();
    String _query;
    if(keyword.isEmpty){
      _query = "select name, phone from outschool where phone is not null";
    } else {
      _query = "select name, phone from outschool where phone is not null and name like '%$keyword%'";
    }
    List<Map> queryResult = await _database.rawQuery(_query);
    searchResult.assignAll(queryResult.map((e) => PhoneNum.fromJson(e)).toList());
    isLoading(false);
    refresh();
  }
}
