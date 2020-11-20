import 'dart:convert';

import 'package:chatbot/config/networking.dart' as conf;
import 'package:chatbot/main.dart';
import 'package:chatbot/model/ReadingRoom.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;

class ReadingRoomController{
  final _allReadingRoomSubject = BehaviorSubject<Map<String, ReadingRoomInfo>>();
  ReadingRoomController(){
    fetch();
  }

  void fetch() async{
    if(readingRoomOpened) {
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

      _allReadingRoomSubject.add(data);
    }
  }

  Stream<Map<String, dynamic>> get allReadingRoom => _allReadingRoomSubject.stream;
}