import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_app_hyuabot_v2/Config/Networking.dart' as conf;
import 'package:flutter_app_hyuabot_v2/Model/Metro.dart';


class FetchMetroInfoController extends GetxController{
  RxMap<String, dynamic> departureInfo = Map<String, dynamic>().obs;
  var isLoading = true.obs;
  var hasError = false.obs;

  @override
  void onInit(){
    queryDepartureInfo();
    super.onInit();
  }

  queryDepartureInfo() async {
    try{
      isLoading(true);
      var data = await fetchDepartureInfo();
      if(data != null){
        departureInfo.assignAll(data);
        isLoading(false);
      }
    } catch (e){
      hasError(false);
    } finally {
      refresh();
    }
    Timer.periodic(Duration(minutes: 1), (timer) async {
      try{
        isLoading(true);
        var data = await fetchDepartureInfo();
        if(data != null){
          departureInfo.assignAll(data);
          isLoading(false);
        }
      } catch (e){
        hasError(false);
      } finally {
        refresh();
      }
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
}