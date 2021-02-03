import 'dart:async';
import 'dart:convert';
import 'package:flutter_app_hyuabot_v2/Config/GlobalVars.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_app_hyuabot_v2/Config/Networking.dart' as conf;
import 'package:flutter_app_hyuabot_v2/Model/ReadingRoom.dart';


class ReadingRoomController extends GetxController{
  RxMap<String, ReadingRoomInfo> readingRoomData = Map<String, ReadingRoomInfo>().obs;
  RxMap<String, bool> readingRoomAlarm = {
    "reading_room_1": false,
    "reading_room_2": false,
    "reading_room_3": false,
    "reading_room_4": false,
  }.obs;
  var isLoading = true.obs;
  var hasError = false.obs;
  @override
  void onInit(){
    queryData();
    super.onInit();
  }

  queryData() async {
    try{
      isLoading(true);
      await fetchSeats();
      await fetchAlarm();
      if(readingRoomData != null && readingRoomAlarm != null){
        isLoading(false);
      }
    } catch(e){
      hasError(true);
    }
    Timer.periodic(Duration(minutes: 1), (timer) async {
      try{
        isLoading(true);
        await fetchSeats();
        await fetchAlarm();
        if(readingRoomData != null && readingRoomAlarm != null){
          isLoading(false);
        }
      } catch(e){
        hasError(true);
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
    readingRoomData.assignAll(data);
    refresh();
  }

  fetchAlarm() async{
    Map<String, bool> data = {
      "reading_room_1": prefManager.read("reading_room_1") ?? false,
      "reading_room_2": prefManager.read("reading_room_2") ?? false,
      "reading_room_3": prefManager.read("reading_room_3") ?? false,
      "reading_room_4": prefManager.read("reading_room_4") ?? false,
    };
    readingRoomAlarm.assignAll(data);
    refresh();
  }
}