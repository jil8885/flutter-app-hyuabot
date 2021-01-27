import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_app_hyuabot_v2/Config/GlobalVars.dart';
import 'package:flutter_app_hyuabot_v2/Config/Networking.dart' as conf;
import 'package:flutter_app_hyuabot_v2/Model/FoodMenu.dart';

class FoodInfoController extends GetxController{
  RxMap<String, Map<String, List<FoodMenu>>> menuList = Map<String, Map<String, List<FoodMenu>>>().obs;

  queryFood(){
    fetchFood().then((value){
      menuList.assignAll(value);
      update();
    });
  }

  Future<Map<String, Map<String, List<FoodMenu>>>> fetchFood() async {
    // food info
    Map<String, Map<String, List<FoodMenu>>> allMenus = {};
    final url = Uri.encodeFull(conf.getAPIServer() + "/app/food");
    final String _localeCode = prefManager.read("localeCode");
    http.Response response;
    response = await http.post(url, body: jsonEncode({'language': _localeCode.split("_")[0]}));
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
    return allMenus;
  }
}