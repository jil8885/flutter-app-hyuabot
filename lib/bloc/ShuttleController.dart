import 'dart:convert';

import 'package:chatbot/config/networking.dart' as conf;
import 'package:chatbot/model/Shuttle.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;

class FetchAllShuttleController{
  // ignore: close_sinks
  final _allShuttleInfoSubject = BehaviorSubject<Map<String, ShuttleStopDepartureInfo>>();
  FetchAllShuttleController(){
    fetch();
  }

  void fetch() async{
    final url = Uri.encodeFull(conf.apiServer + "/app/shuttle");
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