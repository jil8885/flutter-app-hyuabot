import 'package:flutter_app_hyuabot_v2/Config/GlobalVars.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app_hyuabot_v2/Config/Networking.dart' as conf;

import 'package:flutter_app_hyuabot_v2/Model/FoodMenu.dart';

import 'dart:convert';
import 'package:rxdart/rxdart.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class FetchFoodInfoController{
  final _allFoodInfoSubject = BehaviorSubject<Map<String, Map<String, List<FoodMenu>>>>();
  FetchFoodInfoController(){
    fetchFood();
  }

  fetchFood() async {
    // food info
    Map<String, Map<String, List<FoodMenu>>> allMenus = {};
    final url = Uri.encodeFull(conf.getAPIServer() + "/app/food");
    Preference<String> _localeCode = prefManager.getString('localeCode', defaultValue: 'ko');
    http.Response response;
    response = await http.post(url, body: jsonEncode({'language': _localeCode.getValue().split("_")[0]}));
    Map<String, dynamic> responseJson = jsonDecode(utf8.decode(response.bodyBytes));
    for(String name in responseJson.keys){
      if(name.contains("erica")){
        allMenus[name] = {"breakfast": [], "lunch": [], "dinner": []};
        for(String time in responseJson[name].keys){
          switch(time){
            case "조식":
              allMenus[name]['breakfast'] = (responseJson[name][time] as List).map((e) => FoodMenu.fromJson(e)).toList();
              break;
            case "중식":
              allMenus[name]['lunch'] = (responseJson[name][time] as List).map((e) => FoodMenu.fromJson(e)).toList();
              break;
            case "석식":
              allMenus[name]['dinner'] = (responseJson[name][time] as List).map((e) => FoodMenu.fromJson(e)).toList();
              break;
          }
        }
      }
    }
    _allFoodInfoSubject.add(allMenus);
  }

  void dispose(){
    _allFoodInfoSubject.close();
  }
  Stream<Map<String, Map<String, List<FoodMenu>>>> get allFoodInfo => _allFoodInfoSubject.stream;
}