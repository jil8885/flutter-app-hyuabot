import 'package:flutter_app_hyuabot_v2/Model/Store.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class MapController extends GetxController{
  Database _database;
  RxList<Map> markers = List<Map>().obs;
  RxList<StoreSearchInfo> searchResult = List<StoreSearchInfo>().obs;
  var isLoading = true.obs;

  @override
  onInit(){
    while(_database != null){
      loadDatabase();
    }
    super.onInit();
  }

  loadDatabase() {
    String _path;
    getDatabasesPath().then((value){_path = value;}).whenComplete((){
      openDatabase(
          join(_path, "information.db")
      ).then((value){_database = value;}).whenComplete((){searchStore('');});
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

  searchStore(String searchKeyword) async {
    isLoading(true);
    refresh();
    String _query;
    List<Map> queryResult = List<Map>();
    if(searchKeyword.isNotEmpty){
      _query = "select name, phone from outschool where phone is not null and name like '%$searchKeyword%'";
      queryResult = await _database.rawQuery(_query);
    }

    searchResult.assignAll(queryResult.map((e) => StoreSearchInfo.fromJson(e)).toList());
    isLoading(false);
    refresh();
  }}
