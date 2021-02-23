import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart' as localization;

import 'package:flutter_app_hyuabot_v2/Config/GlobalVars.dart';
import 'package:flutter_app_hyuabot_v2/Model/Bus.dart';

class BusCardPaint extends CustomPainter {
  final Map<String, dynamic> data;
  final Color lineColor;
  final BuildContext context;
  bool timeTableOffered;

  BusCardPaint(this.data, this.lineColor, this.context, this.timeTableOffered);

  void drawInfo(Canvas canvas, Offset offset, int numOfStop, int seats, var text, BuildContext context) {
    String _stopString, _seatString;
    switch (
        prefManager.getString("localeCode")) {
      case 'ko_KR':
        _stopString = '$numOfStop전';
        _seatString = '$seats석';
        break;
      case 'en_US':
        _stopString = '($numOfStop Stops left)';
        _seatString = 'Seats: $seats';
        break;
      case 'zh':
        break;
    }

    if(numOfStop >= 0){
      text += " - $_stopString";
    }
    if(seats >= 0){
      text += "($_seatString)";
    }
    TextSpan sp = TextSpan(
        style: TextStyle(
          color: Theme.of(context).backgroundColor == Colors.white ? Colors.black : Colors.white, fontSize: 14, fontFamily: "Godo"),
          text: text
    );
    TextPainter tp = TextPainter(text: sp, textDirection: TextDirection.ltr);
    tp.layout();
    Offset location = Offset(offset.dx, offset.dy - tp.height * .5);
    tp.paint(canvas, location);
  }


  String _getArrivalTime(String time) {
    String _timeString;
    switch (
        prefManager.getString("localeCode")) {
      case 'ko_KR':
        _timeString = '$time 출발';
        break;
      case 'en_US':
        _timeString = 'Leave at $time from terminal stop';
        break;
      case 'zh':
        break;
    }
    return _timeString;
  }

  String _getTime(int time) {
    String _timeString;
    switch (
        prefManager.getString("localeCode")) {
      case 'ko_KR':
        _timeString = '$time분';
        break;
      case 'en_US':
        _timeString = '$time min(s) left';
        break;
      case 'zh':
        break;
    }
    return _timeString;
  }

  @override
  void paint(Canvas canvas, Size size) {
    // Paint for line
    final _line = Paint()
      ..color = Colors.grey
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.0;

    // Paint for White circle
    final _white = Paint()
      ..color = Colors.white
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.0;

    // Paint for line Circle
    final _colorPaint = Paint()
      ..color = lineColor
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.0;

    double _dashWidth = 3;
    double _dashSpace = 2;
    double _start = 10;
    final space = (_dashSpace + _dashWidth);

    while (_start < 35) {
      canvas.drawLine(Offset(0, _start), Offset(0, _start + _dashSpace), _line);
      _start += space;
    }

    canvas.drawCircle(Offset(0, 10), 5.0, _colorPaint);
    canvas.drawCircle(Offset(0, 35), 5.0, _line);
    canvas.drawCircle(Offset(0, 35), 3.0, _white);

    if(data == null){
      return;
    }
    List<BusInfoRealtime> realtimeList = data['realtime'];
    List<BusInfoTimetable> timetableList = data['timetable'];

    if (realtimeList.length >= 2) {
        drawInfo(canvas, Offset(15, 10), realtimeList.elementAt(0).location, realtimeList.elementAt(0).seats, _getTime(realtimeList.elementAt(0).time), context);
        drawInfo(canvas, Offset(15, 35), realtimeList.elementAt(1).location, realtimeList.elementAt(1).seats, _getTime(realtimeList.elementAt(1).time), context);
    } else if (realtimeList.length == 1) {
      drawInfo(canvas, Offset(15, 10), realtimeList.elementAt(0).location, realtimeList.elementAt(0).seats, _getTime(realtimeList.elementAt(0).time), context);
      if (timetableList.isNotEmpty) {
        drawInfo(canvas, Offset(15, 35), -1, -1, _getArrivalTime(timetableList.elementAt(0).time), context);
      } else {
        if (timeTableOffered) {
          drawInfo(canvas, Offset(15, 35), -1, -1, "last_bus".tr(), context);
        } else {
          drawInfo(canvas, Offset(15, 35), -1, -1, "timetable_not_offered".tr(), context);
        }
      }
    } else if (!timeTableOffered) {
      drawInfo(canvas, Offset(15, 10), -1, -1, "timetable_not_offered".tr(), context);
    } else if (timetableList.length >= 2) {
      drawInfo(canvas, Offset(15, 10), -1, -1, _getArrivalTime(timetableList.elementAt(0).time), context);
      drawInfo(canvas, Offset(15, 35), -1, -1, _getArrivalTime(timetableList.elementAt(1).time), context);
    } else if (timetableList.length == 1) {
      drawInfo(canvas, Offset(15, 10), -1, -1, _getArrivalTime(timetableList.elementAt(0).time), context);
      drawInfo(canvas, Offset(15, 35), -1, -1, "last_bus".tr(), context);
    } else {
      drawInfo(canvas, Offset(15, 10), -1, -1, "out_of_service", context);
    }
  }

  @override
  bool shouldRepaint(covariant BusCardPaint oldDelegate) {
    if (oldDelegate.data != this.data) {
      return true;
    } else {
      return false;
    }
  }
}
