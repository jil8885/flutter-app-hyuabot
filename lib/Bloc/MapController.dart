import 'package:flutter_app_hyuabot_v2/Model/Store.dart';
import 'package:get/get.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class MapController extends GetxController{
  Database _database;
  RxMap<String, List<Marker>> markers = Map<String, List<Marker>>().obs;
  RxList<Marker> selectedMarkers = List<Marker>().obs;
  RxList<StoreSearchInfo> searchResult = List<StoreSearchInfo>().obs;
  NaverMapController naverMapController;
  var isLoading = true.obs;

  @override
  onInit(){
    loadDatabase();
    super.onInit();
  }

  loadDatabase()  {
    selectedMarkers.assignAll([]);
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
            OverlayImage.fromAssetImage(assetName: "assets/images/$assetName.png", context: Get.context).then((value){
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
          markers.assignAll(_markers);
          refresh();
        });
      });
    });
  }

  getMarker(String category){
    selectedMarkers.assignAll(markers[category]);
    refresh();
  }

  _onMarkerTap(Marker marker, Map<String, int> iconSize){
    naverMapController.moveCamera(CameraUpdate.scrollTo(LatLng(marker.position.latitude, marker.position.longitude)));
    // Fluttertoast.showToast(msg: _mapController.getInfoWindow(marker.position.latitude, marker.position.longitude));
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
      _query = "select name, menu, latitude, longitude from outschool where phone is not null and name like '%$searchKeyword%'";
      queryResult = await _database.rawQuery(_query);
      searchResult.assignAll(queryResult.map((e) => StoreSearchInfo.fromJson(e)).toList());
    }
    isLoading(false);
    refresh();
  }

  getInfoWindow(double latitude, double longitude) {
    String query = "select name, menu from outschool where latitude=$latitude and longitude=$longitude";
    String storeResult;
    _database.rawQuery(query).then((value){
      storeResult = value.map((e) => "${e["name"]}-${e["menu"]}").toList().join("\n");
      return storeResult;
    });
  }
}
