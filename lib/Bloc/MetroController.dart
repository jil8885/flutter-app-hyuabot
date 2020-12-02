import 'dart:convert';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_app_hyuabot_v2/Config/Networking.dart' as conf;
import 'package:flutter_app_hyuabot_v2/Model/Metro.dart';


class FetchMetroInfoController{
  final _allMetroInfoSubject = BehaviorSubject<Map<String, dynamic>>();
  FetchMetroInfoController(){
    fetch();
  }

  void fetch() async{
    final url = Uri.encodeFull(conf.getAPIServer() + "/app/subway");
    http.Response response = await http.post(url, headers: {"Accept": "application/json"}, body: jsonEncode({"campus": "ERICA"}));
    Map<String, dynamic> responseJson = jsonDecode(utf8.decode(response.bodyBytes));

    Map<String, dynamic> data = {};
    Map<String, dynamic> temp;

    for(String key in responseJson.keys) {
      if (key.contains("Suin")) {
        temp = responseJson[key] as Map<String, dynamic>;
        data['sub'] = {};
        for (String heading in temp.keys) {
          data['sub'][heading] = (temp[heading] as List).map((e) => MetroTimeTableInfo.fromJson(e)).toList();
        }
      } else {
        temp = responseJson[key] as Map<String, dynamic>;
        data['main'] = {};
        for (String heading in temp.keys) {
          data['main'][heading] = (temp[heading] as List).map((e) => MetroRealtimeInfo.fromJson(e)).toList();
        }
      }
    }
    _allMetroInfoSubject.add(data);
  }

  void dispose(){
    _allMetroInfoSubject.close();
  }

  Stream<Map<String, dynamic>> get allMetroInfo => _allMetroInfoSubject.stream;
}