import 'dart:convert';
import 'package:flutter_app_hyuabot_v2/Config/GlobalVars.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_app_hyuabot_v2/Config/Networking.dart' as conf;
import 'package:flutter_app_hyuabot_v2/Model/ReadingRoom.dart';


class ReadingRoomController{
  final _allReadingRoomSubject = BehaviorSubject<Map<String, ReadingRoomInfo>>();
  final _allReadingRoomAlarmSubject = BehaviorSubject<Map<String, bool>>();


  ReadingRoomController(){
    fetch();
    fetchAlarm();
  }

  void fetch() async{
    final url = Uri.encodeFull(conf.getAPIServer() + "/app/library");
    http.Response response = await http.post(
        url, headers: {"Accept": "application/json"},
        body: jsonEncode({"campus": "ERICA"}));
    Map<String, dynamic> responseJson = jsonDecode(
        utf8.decode(response.bodyBytes));
    Map<String, ReadingRoomInfo> data = {};
    for (String key in responseJson.keys) {
      data[key] = ReadingRoomInfo.fromJson(responseJson[key]);
      _allReadingRoomSubject.add(data);
    }
  }

  void fetchAlarm() async{
    Map<String, bool> data = {
      "reading_room_1": prefManager.getBool("reading_room_1"),
      "reading_room_2": prefManager.getBool("reading_room_2"),
      "reading_room_3": prefManager.getBool("reading_room_3"),
      "reading_room_4": prefManager.getBool("reading_room_4"),
    };
    _allReadingRoomAlarmSubject.add(data);
  }

  void refresh() async{
    _allReadingRoomSubject.add(_allReadingRoomSubject.value);
  }

  void dispose(){
    _allReadingRoomSubject.close();
    _allReadingRoomAlarmSubject.close();
  }

  Stream<Map<String, dynamic>> get allReadingRoom => _allReadingRoomSubject.stream;
  Stream<Map<String, bool>> get allReadingRoomAlarm => _allReadingRoomAlarmSubject.stream;
}