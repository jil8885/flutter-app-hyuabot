import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter_app_hyuabot_v2/Config/Networking.dart' as conf;
import 'package:flutter_app_hyuabot_v2/Model/Shuttle.dart';
import 'package:rxdart/rxdart.dart';


class ShuttleDepartureController{
  final BehaviorSubject<Map<String, dynamic>> _subject = BehaviorSubject<Map<String, dynamic>>();

  ShuttleDepartureController(){
    fetchDepartureInfo().then((value){_subject.add(value);});
    Stream _timer = Stream.periodic(Duration(minutes: 1));
    _timer.listen((_) async {
      _subject.add(await fetchDepartureInfo());
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

  dispose(){
    _subject.close();
  }

  Stream<Map<String, dynamic>> get departureInfo => _subject.stream;

}

class ShuttleTimeTableController{
  final BehaviorSubject<Map<String, dynamic>> _subject = BehaviorSubject<Map<String, dynamic>>();

  setBusStop(String busStop) async {
    _subject.add(await fetchTimeTable(busStop));
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

  dispose(){
    _subject.close();
  }

  Stream<Map<String, dynamic>> get departureInfo => _subject.stream;

}