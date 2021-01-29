import 'package:flutter_app_hyuabot_v2/Model/Store.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class MapController extends GetxController{
  Database _database;
  RxList<Map> markers = List<Map>().obs;
  RxList<StoreSearchInfo> searchResult = List<StoreSearchInfo>().obs;

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
      ).then((value){_database = value;});
    });
  }

  getMarkers(String catString) async {
    String query;
    if(catString.trim().isEmpty){
      query = "select distinct latitude, longitude from outschool";
    } else {
      query = "select distinct latitude, longitude from outschool where category='$catString'";
    }
    markers.assignAll(await _database.rawQuery(query));
    refresh();
  }

  getStoreList(String catString, Map marker){
    String query = "select name, menu from outschool where category='$catString' and latitude=${marker['latitude'].toString().trim()} and longitude=${marker['longitude'].toString().trim()}";
    _database.rawQuery(query).then((value){
      String storeResult = value.map((e) => "${e["name"]}-${e["menu"]}").toList().join("\n");
      return storeResult;
    });
  }

  searchStore(String searchKeyword) {
    if(searchKeyword.isNotEmpty){
      String query = "select name, menu, latitude, longitude from outschool where name like '%$searchKeyword%' or menu like '%$searchKeyword%'";
      _database.rawQuery(query).then((value){
        searchResult.assignAll(value.map((e) => StoreSearchInfo.fromJson(e)).toList());
      });
    } else{
      searchResult.assignAll([]);
    }
    refresh();
  }}
