import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'package:flutter_app_hyuabot_v2/Config/Common.dart';

class DateController{
  final List<Color> _colors = [ Colors.blueGrey, Colors.green, Colors.purple, Colors.deepPurple];
  final BehaviorSubject<List<Schedule>> _subject = BehaviorSubject<List<Schedule>>();

  DateController(){
    fetchData().then((value){_subject.add(value);});
  }

  Future<List<Schedule>> fetchData() async{
    List<Schedule> data = [];
    final url = Uri.https("raw.githubusercontent.com", "jil8885/API-for-ERICA/light/calendar/master.json");
    http.Response response = await http.get(url);
    Map<String, dynamic> responseJson = jsonDecode(utf8.decode(response.bodyBytes));
    int index = 0;
    for(String key in responseJson.keys){
      var value = responseJson[key];
      data.add(getJson(key, value, index % 4));
      index++;
    }
    return data;
  }

  Schedule getJson(String key, dynamic value, int index){
    DateTime startDate = getDateTimeFromString(value["start"], 9);
    DateTime endDate = getDateTimeFromString(value["end"], 17);
    return Schedule(
      eventName: key,
      from: startDate,
      to: endDate,
      background: _colors[index],
      isAllDay: false,
      startTimeZone: '',
      endTimeZone: '',
    );
  }

  dispose(){
    _subject.close();
  }

  Stream<List<Schedule>> get scheduleList => _subject.stream;
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