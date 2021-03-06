import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_app_hyuabot_v2/Config/Networking.dart' as conf;
import 'package:flutter_app_hyuabot_v2/Model/Bus.dart';
import 'package:rxdart/rxdart.dart';


class BusDepartureController {
  final BehaviorSubject<Map<String, dynamic>> _subject = BehaviorSubject<Map<String, dynamic>>();
  BusDepartureController(){
    fetchDepartureInfo().then((value){_subject.add(value);});
    Stream _timer = Stream.periodic(Duration(minutes: 1));
    _timer.listen((_) async {
      _subject.add(await fetchDepartureInfo());
    });
  }

  Future<Map<String, dynamic>> fetchDepartureInfo() async{

    final url = kReleaseMode ? Uri.https(conf.getAPIServer(), "/app/bus") : Uri.http(conf.getAPIServer(), "/app/bus");
    http.Response response = await http.post(url, headers: {"Accept": "application/json"}, body: jsonEncode({"campus": "ERICA"}));
    Map<String, dynamic> responseJson = jsonDecode(utf8.decode(response.bodyBytes));
    Map<String, dynamic> data = {"10-1":{"realtime": <BusInfoRealtime>[], "timetable": <BusInfoTimetable>[]}, "3102": {"realtime": <BusInfoRealtime>[], "timetable": <BusInfoTimetable>[]}, "707-1": {"realtime": <BusInfoRealtime>[], "timetable": <BusInfoTimetable>[]}};

    for(String key in (responseJson["realtime"] as Map<String, dynamic>).keys){
      List realtimeInfo = responseJson["realtime"][key];
      if(realtimeInfo.isNotEmpty) {
        data[key]["realtime"] =
            realtimeInfo.map((e) => BusInfoRealtime.fromJson(e)).toList();
      } else {
        data[key]["realtime"] = <BusInfoRealtime>[];
      }
    }

    for(String key in (responseJson["timetable"] as Map<String, dynamic>).keys){
      List timetableInfo = responseJson["timetable"][key];
      if(timetableInfo.isNotEmpty) {
        data[key]["timetable"] =
            timetableInfo.map((e) => BusInfoTimetable.fromJson(e)).toList();
      }else{
        data[key]["timetable"] = <BusInfoTimetable>[];
      }
    }
    return data;
  }

  dispose(){
    _subject.close();
  }

  Stream<Map<String, dynamic>> get busDepartureInfo => _subject.stream;
}

class BusTimetableController{
  final BehaviorSubject<Map<String, dynamic>> _subject = BehaviorSubject<Map<String, dynamic>>();

  setRoute(String route) async {
    _subject.add(await fetchTimeTable(route));
  }

  fetchTimeTable(String route) async{
    final url = kReleaseMode ? Uri.https(conf.getAPIServer(), "/app/bus/timetable") : Uri.http(conf.getAPIServer(), "/app/bus/timetable");
    http.Response response = await http.post(url, headers: {"Accept": "application/json"}, body: jsonEncode({"campus": "ERICA", "route": route}));
    Map<String, dynamic> responseJson = jsonDecode(utf8.decode(response.bodyBytes));
    Map<String, dynamic> data = {"day": responseJson["day"], "weekdays": responseJson["weekdays"], "saturday": responseJson["saturday"], "sunday": responseJson["sunday"]};
    return data;
  }

  dispose(){
    _subject.close();
  }

  Stream<Map<String, dynamic>> get timetableInfo => _subject.stream;
}