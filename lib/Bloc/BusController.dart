import 'dart:convert';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_app_hyuabot_v2/Config/Networking.dart' as conf;
import 'package:flutter_app_hyuabot_v2/Model/Bus.dart';


class FetchBusInfoController{
  final _allBusInfoSubject = BehaviorSubject<Map<String, dynamic>>();
  FetchBusInfoController(){
    fetch();
  }

  void fetch() async{
    final url = Uri.encodeFull(conf.getAPIServer() + "/app/bus");
    http.Response response = await http.post(url, headers: {"Accept": "application/json"}, body: jsonEncode({"campus": "ERICA"}));
    Map<String, dynamic> responseJson = jsonDecode(utf8.decode(response.bodyBytes));

    Map<String, dynamic> data = {"10-1":{"realtime": List<BusInfoRealtime>(), "timetable": List<BusInfoTimetable>()}, "3102": {"realtime": List<BusInfoRealtime>(), "timetable": List<BusInfoTimetable>()}, "707-1": {"realtime": List<BusInfoRealtime>(), "timetable": List<BusInfoTimetable>()}};

    for(String key in (responseJson["realtime"] as Map<String, dynamic>).keys){
      List realtimeInfo = responseJson["realtime"][key];
      if(realtimeInfo.isNotEmpty) {
        data[key]["realtime"] =
            realtimeInfo.map((e) => BusInfoRealtime.fromJson(e)).toList();
      } else {
        data[key]["realtime"] = new List<BusInfoRealtime>();
      }
    }

    for(String key in (responseJson["timetable"] as Map<String, dynamic>).keys){
      List timetableInfo = responseJson["timetable"][key];
      if(timetableInfo.isNotEmpty) {
        data[key]["timetable"] =
            timetableInfo.map((e) => BusInfoTimetable.fromJson(e)).toList();
      }else{
        data[key]["timetable"] = new List<BusInfoTimetable>();
      }
    }
    _allBusInfoSubject.add(data);
  }

  void dispose(){
    _allBusInfoSubject.close();
  }

  Stream<Map<String, dynamic>> get allBusInfo => _allBusInfoSubject.stream;
}