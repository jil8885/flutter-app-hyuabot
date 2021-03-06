import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_app_hyuabot_v2/Config/GlobalVars.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_app_hyuabot_v2/Config/Networking.dart' as conf;
import 'package:flutter_app_hyuabot_v2/Model/ReadingRoom.dart';
import 'package:rxdart/rxdart.dart';


class ReadingRoomController{
  final BehaviorSubject<Map<String, dynamic>> _subject = BehaviorSubject<Map<String, dynamic>>();

  ReadingRoomController(){
    fetchSeats().then((value){
      _subject.add({"alarm": {
        "reading_room_1": false,
        "reading_room_2": false,
        "reading_room_3": false,
        "reading_room_4": false,
      }, "seats": value});
    });
    Stream _timer = Stream.periodic(Duration(minutes: 1));
    _timer.listen((_) async {
      _subject.add({"alarm": await fetchAlarm(), "seats": await fetchSeats()});
    });
  }


  Future<Map<String, ReadingRoomInfo>> fetchSeats() async{
    final url = kReleaseMode ? Uri.https(conf.getAPIServer(), "/app/library") : Uri.http(conf.getAPIServer(), "/app/library");
    http.Response response = await http.post(
        url, headers: {"Accept": "application/json"},
        body: jsonEncode({"campus": "ERICA"}));
    Map<String, dynamic> responseJson = jsonDecode(
        utf8.decode(response.bodyBytes));
    Map<String, String> roomCode = {"제1열람실":"reading_room_1", "제2열람실":"reading_room_2", "제3열람실":"reading_room_3", "제4열람실":"reading_room_4", "제5열람실":"reading_room_5"};
    Map<String, ReadingRoomInfo> data = {};
    for (String key in responseJson.keys) {
      data[roomCode[key]!] = ReadingRoomInfo.fromJson(responseJson[key]);
    }
    return data;
  }

  fetchAlarm() async{
    Map<String, bool> data = {
      "reading_room_1": prefManager!.getBool("reading_room_1") ?? false,
      "reading_room_2": prefManager!.getBool("reading_room_2") ?? false,
      "reading_room_3": prefManager!.getBool("reading_room_3") ?? false,
      "reading_room_4": prefManager!.getBool("reading_room_4") ?? false,
    };
    return data;
  }

  updateAlarm() async {
    _subject.add({"seats":_subject.value!["seats"], "alarm": await fetchAlarm()});
  }

  dispose(){
    _subject.close();
  }

  Stream<Map<String, dynamic>> get currentData => _subject.stream;
}