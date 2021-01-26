import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'package:flutter_app_hyuabot_v2/Config/Common.dart';

class DateController extends GetxController{
  final List<Color> _colors = [Colors.grey, Colors.blueGrey, Colors.green, Colors.purple, Colors.deepPurple];
  MeetingDataSource meetingDataSource = MeetingDataSource([]);

  queryData() async {
    meetingDataSource = await fetchData();
    update();
  }

  fetchData() async{
    List<Schedule> data = [];
    final url = Uri.encodeFull("https://raw.githubusercontent.com/jil8885/API-for-ERICA/light/calendar/master.json");
    http.Response response = await http.get(url);
    Map<String, dynamic> responseJson = jsonDecode(utf8.decode(response.bodyBytes));
    for(String key in responseJson.keys){
      var value = responseJson[key];
      data.add(getJson(key, value));
    }
    return MeetingDataSource(data);
  }

  Schedule getJson(String key, dynamic value){
    DateTime startDate = getDateTimeFromString(value["start"], 9);
    DateTime endDate = getDateTimeFromString(value["end"], 17);
    return Schedule(
      eventName: key,
      from: startDate,
      to: endDate,
      background: (_colors..shuffle()).first,
      isAllDay: false,
      startTimeZone: '',
      endTimeZone: '',
    );
  }
}

class Schedule {
  Schedule({this.eventName, this.from, this.to, this.background, this.isAllDay, this.startTimeZone, this.endTimeZone});

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
  String startTimeZone;
  String endTimeZone;
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Schedule> source){
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments[index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments[index].to;
  }

  @override
  bool isAllDay(int index) {
    return appointments[index].isAllDay;
  }

  @override
  String getSubject(int index) {
    return appointments[index].eventName;
  }

  @override
  String getStartTimeZone(int index) {
    return appointments[index].startTimeZone;
  }

  @override
  String getEndTimeZone(int index) {
    return appointments[index].endTimeZone;
  }

  @override
  Color getColor(int index) {
    return appointments[index].background;
  }
}