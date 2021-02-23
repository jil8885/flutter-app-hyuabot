import 'package:flutter/cupertino.dart';
import 'package:flutter_app_hyuabot_v2/Model/Store.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';
import 'package:path/path.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sqflite/sqflite.dart';

class MapController{
  Database _database;
  final BehaviorSubject<Map<String, List<Marker>>> _markerSubject = BehaviorSubject<Map<String, List<Marker>>>();
  final BehaviorSubject<List<Marker>> _selectedMarkerSubject = BehaviorSubject<List<Marker>>();
  final BehaviorSubject<List<StoreSearchInfo>> _resultSubject = BehaviorSubject<List<StoreSearchInfo>>();
  NaverMapController naverMapController;

  final BuildContext context;
  MapController(this.context){
    _resultSubject.add([]);
  }

  loadDatabase()  {
    _selectedMarkerSubject.add([]);
    String _path;
    getDatabasesPath().then((value){_path = value;}).whenComplete((){
      openDatabase(
          join(_path, "information.db")
      ).then((value){_database = value;}).whenComplete((){
        String query = "select distinct category, latitude, longitude from outschool";
        List<Map> queryResult;
        _database.rawQuery(query).then((value){queryResult = value;}).whenComplete((){
          Map<String, List<Marker>> _markers = Map<String, List<Marker>>();
          int index = 0;
          for(Map marker in queryResult){
            String assetName = "restaurant";
            if(marker["category"] == "pub"){
              assetName = "pub";
            } else if(marker["category"] == "cafe"){
              assetName = "cafe";
            }
            OverlayImage image;
            OverlayImage.fromAssetImage(assetName: "assets/images/$assetName.png", context: context).then((value){
              image = value;
            });
            String query = "select name, menu from outschool where category='${marker["category"]}' and latitude=${marker['latitude'].toString().trim()} and longitude=${marker['longitude'].toString().trim()}";
            List<Map> queryResult;
            _database.rawQuery(query).then((value){queryResult = value;}).whenComplete((){
              String storeResult = queryResult.map((e) => "${e["name"]}-${e["menu"]}").toList().join("\n");
              if(!_markers.containsKey(marker["category"])){
                _markers[marker["category"]] = [];
              }
              _markers[marker["category"]].add(Marker(
                  markerId: '$index',
                  position: LatLng(double.parse(marker['latitude'].toString()), double.parse(marker['longitude'].toString())),
                  icon: image,
                  width: 20,
                  height: 20,
                  captionText: marker["category"],
                  infoWindow: storeResult,
                  onMarkerTab: _onMarkerTap
              ));
              index++;
            });
          }
          _markerSubject.add(_markers);
        });
      });
    });
  }

  getMarker(String category){
    _selectedMarkerSubject.add(_markerSubject.value[category]);
  }

  _onMarkerTap(Marker marker, Map<String, int> iconSize){
    naverMapController.moveCamera(CameraUpdate.scrollTo(LatLng(marker.position.latitude, marker.position.longitude)));
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
    _markerSubject.close();
    _resultSubject.close();
  }

  Stream<Map<String, List<Marker>>> get markers => _markerSubject.stream;
  Stream<List<Marker>> get selectedMarkers => _selectedMarkerSubject.stream;
  Stream<List<StoreSearchInfo>> get searchResult => _resultSubject.stream;

}
