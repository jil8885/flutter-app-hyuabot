import 'package:flutter/material.dart';
import 'package:flutter_app_hyuabot_v2/Config/GlobalVars.dart';
import 'package:flutter_app_hyuabot_v2/UI/CustomCard.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';
import 'package:path/path.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sqflite/sqflite.dart';

class DataBaseController{
  final BuildContext context;
  Database _database;
  String _path;

  DataBaseController([this.context]);
  final _phoneSearchResultInSchool = BehaviorSubject<List<PhoneNum>>();
  final _phoneSearchResultOutSchool = BehaviorSubject<List<PhoneNum>>();

  Future init() async{
    _path = await getDatabasesPath();
    _database = await openDatabase(join(_path, "information.db"));
  }

  fetchInSchoolList([String name]) async{
    String query = "select name, phone from inschool where phone is not null";
    if(name != null && name.isNotEmpty){
      query += " and name like '%$name%'";
    }
    List<Map> queryResult = await _database.rawQuery(query);
    if(queryResult.isEmpty){
      _phoneSearchResultInSchool.add([]);
    } else {
      _phoneSearchResultInSchool.add(queryResult.map((e) => PhoneNum.fromJson(e)).toList());
    }
  }

  fetchOutSchoolList([String name]) async{
    String query = "select name, phone from outschool where phone is not null";
    if(name != null && name.isNotEmpty){
      query += " and name like '%$name%'";
    }
    List<Map> queryResult = await _database.rawQuery(query);
    if(queryResult.isEmpty){
      _phoneSearchResultOutSchool.add([]);
    } else {
      _phoneSearchResultOutSchool.add(queryResult.map((e) => PhoneNum.fromJson(e)).toList());
    }
  }


  Future<List<Marker>> fetchMarkers(String catString) async{
    String query = "select distinct latitude, longitude from outschool where category='$catString'";
    List<Map> queryResult = await _database.rawQuery(query);
    List<Marker> _markers = [];
    int index = 0;
    String assetName = "restaurant";
    if(catString == "pub"){
      assetName = "pub";
    } else if(catString == "cafe"){
      assetName = "cafe";
    }
    OverlayImage image = await OverlayImage.fromAssetImage(ImageConfiguration(), "assets/images/$assetName.png");
    for(Map marker in queryResult){
      String query = "select name from outschool where category='$catString' and latitude=${marker['latitude']} and longitude=${marker['longitude']}";
      String storeResult = (await _database.rawQuery(query)).map((e) => e["name"]).toList().join(",");
      _markers.add(Marker(
          markerId: '$index',
          position: LatLng(double.parse(marker['latitude'].toString()), double.parse(marker['longitude'].toString())),
          icon: image,
          width: 20,
          height: 20,
          captionText: catString,
          infoWindow: storeResult,
          onMarkerTab: _onMarkerTap
        )
      );
      index++;
    }
    return _markers;
  }


  Future<List<StoreInfo>> fetchStore(String catString, double latitude, double longitude) async{
    String query = "select name, phone, menu from outschool where latitude=$latitude and longitude=${double.parse(longitude.toStringAsFixed(12))} and category='$catString'";
    List<Map> queryResult = await _database.rawQuery(query);
    return queryResult.map((e) => StoreInfo.fromJson(e)).toList();
  }


  _onMarkerTap(Marker marker, Map<String, int> iconSize){
    mapController.moveCamera(CameraUpdate.scrollTo(LatLng(marker.position.latitude, marker.position.longitude)));
  }

  dispose(){
    _phoneSearchResultInSchool.close();
    _phoneSearchResultOutSchool.close();
    _database.close();
  }

  Stream<List<PhoneNum>> get searchPhoneResultInSchool => _phoneSearchResultInSchool.stream;
  Stream<List<PhoneNum>> get searchPhoneResultOutSchool => _phoneSearchResultOutSchool.stream;

}

class PhoneNum{
  final String name;
  final String number;
  PhoneNum(this.name, this.number);

  factory PhoneNum.fromJson(Map<String, dynamic> json){
    return PhoneNum(json["name"], json['phone']);
  }
}

class StoreInfo{
  final String name;
  final String number;
  final String menu;

  StoreInfo(this.name, this.number, this.menu);

  factory StoreInfo.fromJson(Map<String, dynamic> json){
    return StoreInfo(json["name"], json['phone'], json['menu']);
  }
}