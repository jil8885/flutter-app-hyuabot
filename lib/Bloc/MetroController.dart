import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter_app_hyuabot_v2/Config/Networking.dart' as conf;
import 'package:flutter_app_hyuabot_v2/Model/Metro.dart';
import 'package:rxdart/rxdart.dart';


class FetchMetroInfoController{
  final BehaviorSubject<Map<String, dynamic>> _subject = BehaviorSubject<Map<String, dynamic>>();

  FetchMetroInfoController(){
    fetchDepartureInfo().then((value){
      _subject.add(value);
    });
    Stream _timer =  Stream.periodic(Duration(minutes: 1));
    _timer.listen((_) async {
      _subject.add(await fetchDepartureInfo());
    });
  }

  fetchDepartureInfo() async{
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
        temp = responseJson[key] as Map<String, dynamic> ?? {"up":[], "down":[]};
        data['main'] = {};
        for (String heading in temp.keys) {
          data['main'][heading] = (temp[heading] as List).map((e) => MetroRealtimeInfo.fromJson(e)).toList();
        }
      }
    }
    return data;
  }

  dispose(){
    _subject.close();
  }

  Stream<Map<String, dynamic>> get departureInfo => _subject.stream;

}