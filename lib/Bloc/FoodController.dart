import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_app_hyuabot_v2/Config/GlobalVars.dart';
import 'package:flutter_app_hyuabot_v2/Config/Networking.dart' as conf;
import 'package:flutter_app_hyuabot_v2/Model/FoodMenu.dart';
import 'package:rxdart/rxdart.dart';

class FoodInfoController{
  final BehaviorSubject<Map<String, Map<String, List<FoodMenu>>>> _menuSubject = BehaviorSubject<Map<String, Map<String, List<FoodMenu>>>>();
  final BehaviorSubject<List<bool>> _expandSubject = BehaviorSubject<List<bool>>();

  FoodInfoController(){
    _expandSubject.add([false, false, false, false, false]);
    fetchFood().then((value){
      _menuSubject.add(value);
    });
  }

  Future<Map<String, Map<String, List<FoodMenu>>>> fetchFood() async {
    // food info
    Map<String, Map<String, List<FoodMenu>>> allMenus = {};
    final url = kReleaseMode ? Uri.https(conf.getAPIServer(), "/app/food") : Uri.http(conf.getAPIServer(), "/app/food");
    final String _localeCode = prefManager!.getString("localeCode") ?? "ko_KR";
    http.Response response;
    response = await http.post(url, body: jsonEncode({'language': _localeCode.split("_")[0]}));
    Map<String, dynamic> responseJson = jsonDecode(utf8.decode(response.bodyBytes));
    for(String name in responseJson.keys){
      if(name.contains("erica")){
        allMenus[name] = {"breakfast": [], "lunch": [], "dinner": []};
        for(String time in responseJson[name].keys){
          switch(time){
            case "조식":
              allMenus[name]!['breakfast'] = (responseJson[name][time] as List).map((e) => FoodMenu.fromJson(e)).toList();
              break;
            case "중식":
              allMenus[name]!['lunch'] = (responseJson[name][time] as List).map((e) => FoodMenu.fromJson(e)).toList();
              break;
            case "석식":
              allMenus[name]!['dinner'] = (responseJson[name][time] as List).map((e) => FoodMenu.fromJson(e)).toList();
              break;
          }
        }
      }
    }
    return allMenus;
  }

  expandCard(int cardIndex) {
    var data = _expandSubject.value;
    data![cardIndex] = !data[cardIndex];
    _expandSubject.add(data);
  }

  dispose(){
    _expandSubject.close();
    _menuSubject.close();
  }

  Stream<Map<String, dynamic>> get menuInfo => _menuSubject.stream;
  Stream<List<bool>> get expandInfo => _expandSubject.stream;
}