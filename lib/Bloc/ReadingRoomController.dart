import 'dart:async';
import 'dart:convert';
import 'package:flutter_app_hyuabot_v2/Config/GlobalVars.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_app_hyuabot_v2/Config/Networking.dart' as conf;
import 'package:flutter_app_hyuabot_v2/Model/ReadingRoom.dart';


class ReadingRoomController extends GetxController{
  RxMap<String, ReadingRoomInfo> readingRoomData = Map<String, ReadingRoomInfo>().obs;
  RxMap<String, bool> readingRoomAlarm = Map<String, bool>().obs;
  var isLoading = true.obs;

  @override
  void onInit(){
    queryData();
    super.onInit();
  }

  queryData() async {
    try{
      isLoading(true);
      var seatData = await fetchSeats();
      var alarmData = await fetchAlarm();
      if(seatData != null && alarmData != null){
        readingRoomData.assignAll(seatData);
        readingRoomAlarm.assignAll(alarmData);
      }
    } finally {
      isLoading(false);
      refresh();
    }
    Timer.periodic(Duration(minutes: 1), (timer) async {
      try{
        isLoading(true);
        var seatData = await fetchSeats();
        var alarmData = await fetchAlarm();
        if(seatData != null && alarmData != null){
          readingRoomData.assignAll(seatData);
          readingRoomAlarm.assignAll(alarmData);
        }
      } finally {
        isLoading(false);
        refresh();
      }
    });
  }

  fetchSeats() async{
    final url = Uri.encodeFull(conf.getAPIServer() + "/app/library");
    http.Response response = await http.post(
        url, headers: {"Accept": "application/json"},
        body: jsonEncode({"campus": "ERICA"}));
    Map<String, dynamic> responseJson = jsonDecode(
        utf8.decode(response.bodyBytes));
    Map<String, ReadingRoomInfo> data = {};
    for (String key in responseJson.keys) {
      data[key] = ReadingRoomInfo.fromJson(responseJson[key]);
    }
    return data;
  }

  fetchAlarm() async{
    Map<String, bool> data = {
      "reading_room_1": prefManager.read("reading_room_1"),
      "reading_room_2": prefManager.read("reading_room_2"),
      "reading_room_3": prefManager.read("reading_room_3"),
      "reading_room_4": prefManager.read("reading_room_4"),
    };
    return data;
  }
}