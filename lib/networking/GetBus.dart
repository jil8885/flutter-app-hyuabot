import 'package:chatbot/model/Bus.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:chatbot/config/networking.dart' as conf;

Future getBusInfoList() async{
  final url = Uri.encodeFull(conf.apiServer + "/app/bus");
  http.Response response = await http.post(url, headers: {"Accept": "application/json"}, body: jsonEncode({"campus":"ERICA"}));
  Map<String, dynamic> responseJson = jsonDecode(response.body);
  Map<String, BusInfoRealtime> busArrivalList = {};

  List<String> routes = responseJson['realtime'].keys.toList();

  for(String key in routes){
    if((responseJson['realtime'][key] as List).length > 0){
      busArrivalList[key] = BusInfoRealtime.fromJson(responseJson['realtime'][key][0]);
    } else{
      busArrivalList[key] = BusInfoRealtime(-1, -1, -1);
    }

  }

  Map<String, List<BusInfoTimetable>> busTimeTableList = {};
  for(String key in routes){
      busTimeTableList[key] = [];
      if(responseJson['timetable'][key] != null) {
        for (Map<String, dynamic> time in responseJson['timetable'][key]) {
          busTimeTableList[key].add(BusInfoTimetable.fromJson(time));
        }
      }
  }
  return [busArrivalList, busTimeTableList];
}