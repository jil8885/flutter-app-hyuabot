import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_app_hyuabot_v2/Config/Networking.dart' as conf;
import 'package:rxdart/rxdart.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class DateController{
  final _scheduleSubject = BehaviorSubject<MeetingDataSource>();
  DateController(){
    fetch();
  }

  void fetch() async{
    List<Schedule> data = [];
    data.add(
      Schedule(
        eventName: "복학 신청",
        from: DateTime(2021, 1, 7, 9),
        to: DateTime(2021, 1, 15, 18),
        background: Colors.blue,
        isAllDay: false,
        startTimeZone: '',
        endTimeZone: '',
      )
    );
    _scheduleSubject.add(MeetingDataSource(data));
  }

  void dispose(){
    _scheduleSubject.close();
  }

  Stream<MeetingDataSource> get allSchedule => _scheduleSubject.stream;
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