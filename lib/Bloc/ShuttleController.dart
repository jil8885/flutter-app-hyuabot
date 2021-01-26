import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_app_hyuabot_v2/Config/Networking.dart' as conf;
import 'package:flutter_app_hyuabot_v2/Model/Shuttle.dart';


class ShuttleDepartureController extends GetxController{
  Map<String, ShuttleStopDepartureInfo> departureInfo = {};

  queryDepartureInfo() {
    Timer.periodic(Duration(minutes: 1), (timer) async {
      departureInfo = await fetchDepartureInfo();
      update();
    });
  }

  Future<Map<String, ShuttleStopDepartureInfo>> fetchDepartureInfo() async{
    final url = Uri.encodeFull(conf.getAPIServer() + "/app/shuttle");
    http.Response response = await http.get(url, headers: {"Accept": "application/json"});
    Map<String, dynamic> responseJson = jsonDecode(response.body);

    Map<String, ShuttleStopDepartureInfo> data = {};
    for(String key in responseJson.keys){
      data[key] = ShuttleStopDepartureInfo.fromJson(responseJson[key]);
    }
    return data;
  }
}

class ShuttleTimeTableController extends GetxController{
  Map<String, dynamic> timeTableInfo = {};

  queryTimetableInfo(String busStop) async {
    timeTableInfo = await fetchTimeTable(busStop);
    update();
  }

  Future<Map<String, dynamic>> fetchTimeTable(String busStop) async{
    final url = Uri.encodeFull(conf.getAPIServer() + "/app/shuttle/by-stop");
    http.Response response = await http.post(url, headers: {"Accept": "application/json"}, body: jsonEncode({"busStop": busStop}));
    Map<String, dynamic> responseJson = jsonDecode(response.body);
    Map<String, dynamic> data = {};
    data["weekdays"] = ShuttleStopDepartureInfo.fromJson(responseJson["weekdays"]);
    data["weekends"] = ShuttleStopDepartureInfo.fromJson(responseJson["weekends"]);
    data["day"] = responseJson["day"];
    return data;
  }
}