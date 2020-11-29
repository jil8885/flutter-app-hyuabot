import 'dart:convert';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_app_hyuabot_v2/Config/Networking.dart' as conf;
import 'package:flutter_app_hyuabot_v2/Model/Shuttle.dart';


class FetchAllShuttleController{
  final _allShuttleInfoSubject = BehaviorSubject<Map<String, ShuttleStopDepartureInfo>>();
  FetchAllShuttleController(){
    fetch();
  }

  void fetch() async{
    final url = Uri.encodeFull(conf.getAPIServer() + "/app/shuttle");
    http.Response response = await http.get(url, headers: {"Accept": "application/json"});
    Map<String, dynamic> responseJson = jsonDecode(response.body);

    // Map<String, ShuttleStopDepartureInfo> shuttleStopInfoList = getShuttleList(responseJson);
    _allShuttleInfoSubject.add({});
    Map<String, ShuttleStopDepartureInfo> data = {};
    for(String key in responseJson.keys){
      data[key] = ShuttleStopDepartureInfo.fromJson(responseJson[key]);
    }
    _allShuttleInfoSubject.add(data);
  }

  Stream<Map<String, ShuttleStopDepartureInfo>> get allShuttleInfo => _allShuttleInfoSubject.stream;
}