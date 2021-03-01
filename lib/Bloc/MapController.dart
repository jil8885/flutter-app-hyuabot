import 'package:flutter/cupertino.dart';
import 'package:flutter_app_hyuabot_v2/Model/Store.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';
import 'package:path/path.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sqflite/sqflite.dart';

class MapController{
  Database _database;
  final BehaviorSubject<List<Marker>> _selectedMarkerSubject = BehaviorSubject<List<Marker>>();
  final BehaviorSubject<List<StoreSearchInfo>> _resultSubject = BehaviorSubject<List<StoreSearchInfo>>();

  final BuildContext context;
  MapController(this.context){
    loadDatabase();
    _resultSubject.add([]);
  }

  loadDatabase()  {
    _selectedMarkerSubject.add([]);
    String _path;
    getDatabasesPath().then((value){_path = value;}).whenComplete((){
      openDatabase(
          join(_path, "information.db")
      ).then((value){_database = value;});
    });
  }
  getMarker(String category) async {
    List<Marker> _markers = List<Marker>();
    int index = 0;
    String query = "select distinct category, latitude, longitude from outschool where category='$category'";
    List<Map> markerPosition = await _database.rawQuery(query);
    for(Map marker in markerPosition){
      String assetName = "restaurant";
      if (marker["category"] == "pub") {
        assetName = "pub";
      } else if (marker["category"] == "cafe") {
        assetName = "cafe";
      }
      OverlayImage image = await OverlayImage.fromAssetImage(assetName: "assets/images/$assetName.png", context: context);
      query = "select name, menu from outschool where category='${marker["category"]}' and latitude=${marker['latitude'].toString().trim()} and longitude=${marker['longitude'].toString().trim()}";
      List<Map> storeList = await _database.rawQuery(query);
      _markers.add(Marker(
          markerId: '$index',
          position: LatLng(double.parse(marker['latitude'].toString()),
              double.parse(marker['longitude'].toString())),
          icon: image,
          width: 20,
          height: 20,
          captionText: marker["category"],
          infoWindow: storeList.map((e) => "${e["name"]}-${e["menu"]}").toList().join("\n"),
      ));
      index++;
    }
    _selectedMarkerSubject.add(_markers);
  }

  selectMarker(List<Marker> markers){
    _selectedMarkerSubject.add(markers);
  }
  getStoreList(String catString, Map marker){
    String query = "select name, menu from outschool where category='$catString' and latitude=${marker['latitude'].toString().trim()} and longitude=${marker['longitude'].toString().trim()}";
    _database.rawQuery(query).then((value){
      String storeResult = value.map((e) => "${e["name"]}-${e["menu"]}").toList().join("\n");
      return storeResult;
    });
  }

  searchStore(String searchKeyword) async {
    String _query;
    List<Map> queryResult = List<Map>();
    if(searchKeyword.isNotEmpty){
      _query = "select name, menu, latitude, longitude from outschool where phone is not null and name like '%$searchKeyword%'";
      queryResult = await _database.rawQuery(_query);
      _resultSubject.add(queryResult.map((e) => StoreSearchInfo.fromJson(e)).toList());
    }
  }

  getInfoWindow(double latitude, double longitude) {
    String query = "select name, menu from outschool where latitude=$latitude and longitude=$longitude";
    String storeResult;
    _database.rawQuery(query).then((value){
      storeResult = value.map((e) => "${e["name"]}-${e["menu"]}").toList().join("\n");
      return storeResult;
    });
  }

  dispose(){
    _selectedMarkerSubject.close();
    _resultSubject.close();
  }

  Stream<List<Marker>> get selectedMarkers => _selectedMarkerSubject.stream;
  Stream<List<StoreSearchInfo>> get searchResult => _resultSubject.stream;

}
