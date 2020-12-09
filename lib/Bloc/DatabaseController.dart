import 'package:flutter/material.dart';
import 'package:flutter_app_hyuabot_v2/UI/CustomCard.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DataBaseController{
  final BuildContext context;
  DataBaseController(this.context);

  Future<List<Marker>> fetchMarkers(String catString) async{
    String query = "select distinct latitude, longitude from outschool where category='$catString'";
    var path = await getDatabasesPath();
    var database = await openDatabase(join(path, "information.db"));
    List<Map> queryResult = await database.rawQuery(query);
    await database.close();
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
      _markers.add(Marker(markerId: '$index', position: LatLng(double.parse(marker['latitude'].toString()), double.parse(marker['longitude'].toString())), onMarkerTab: _onMarkerTap, icon: image, width: 20, height: 20, captionText: catString));
      index++;
    }
    return _markers;
  }


  Future<List<StoreInfo>> fetchStore(String catString, double latitude, double longitude) async{
    String query = "select name, phone, menu from outschool where latitude=$latitude and longitude=${double.parse(longitude.toStringAsFixed(12))} and category='$catString'";

    var path = await getDatabasesPath();
    var database = await openDatabase(join(path, "information.db"));
    List<Map> queryResult = await database.rawQuery(query);
    await database.close();
    return queryResult.map((e) => StoreInfo.fromJson(e)).toList();
  }


  _onMarkerTap(Marker marker, Map<String, int> iconSize){
    fetchStore(marker.captionText, marker.position.latitude, marker.position.longitude).then(
        (value) {
          showMaterialModalBottomSheet(
              context: context,
              backgroundColor: Colors.white.withOpacity(0.1),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
              builder: (context) => Container(
                margin: EdgeInsets.only(left: 10, right: 10),
                height: 135,
                child: ListView.builder(
                  padding: EdgeInsets.all(5),
                  shrinkWrap: true,
                  itemCount: value.length,
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index){
                    return CustomStoreCard(value[index]);
                  },
                ),
              )
          );
      }
    );
  }
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