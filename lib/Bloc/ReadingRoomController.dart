import 'dart:convert';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_app_hyuabot_v2/Config/Networking.dart' as conf;
import 'package:flutter_app_hyuabot_v2/Model/ReadingRoom.dart';


class ReadingRoomController{
  final _allReadingRoomSubject = BehaviorSubject<Map<String, ReadingRoomInfo>>();
  ReadingRoomController(){
    fetch();
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

  void refresh() async{
    _allReadingRoomSubject.add(_allReadingRoomSubject.value);
  }

  Stream<Map<String, dynamic>> get allReadingRoom => _allReadingRoomSubject.stream;
}