import 'package:chatbot/model/Shuttle.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:chatbot/config/networking.dart' as conf;

Future getShuttleBusInfoList() async{
  final url = Uri.encodeFull(conf.apiServer + "/app/shuttle");
  http.Response response = await http.get(url, headers: {"Accept": "application/json"});
  Map<String, dynamic> responseJson = jsonDecode(response.body);

  Map<String, ShuttleStopInfo> shuttleStopInfoList = getShuttleList(responseJson);

  return shuttleStopInfoList;
}