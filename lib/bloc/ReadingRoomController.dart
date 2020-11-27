import 'dart:convert';

import 'package:chatbot/config/Networking.dart' as conf;
import 'package:chatbot/model/ReadingRoom.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;

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