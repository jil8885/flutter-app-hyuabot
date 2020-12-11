import 'package:flutter/material.dart';
import 'package:flutter_app_hyuabot_v2/Config/GlobalVars.dart';
import 'package:flutter_app_hyuabot_v2/Config/Localization.dart';
import 'package:flutter_app_hyuabot_v2/Model/Bus.dart';

class BusCardPaint extends CustomPainter{
  final Map<String, dynamic> data;
  final Color lineColor;
  final BuildContext context;
  bool timeTableOffered;

  BusCardPaint(this.data, this.lineColor, this.context, this.timeTableOffered);

  void drawRemainedTime(Canvas canvas, Offset offset, String text, BuildContext context) {
    TextSpan sp = TextSpan(style: TextStyle(color: Theme.of(context).backgroundColor == Colors.white ? Colors.black : Colors.white, fontSize: 14, fontFamily: "Godo"), text: text);
    TextPainter tp = TextPainter(text: sp, textDirection: TextDirection.ltr);
    tp.layout();
    Offset location = Offset(offset.dx, offset.dy - tp.height * .5);
    tp.paint(canvas, location);
  }

  void drawInfo(Canvas canvas, Offset offset, int numOfStop, BuildContext context) {
    String _stopString;
    switch(prefManager.getString("localeCode", defaultValue: "ko_KR").getValue()){
      case 'ko_KR':
        _stopString = '$numOfStop번째 전';
        break;
      case 'en_US':
        _stopString = '($numOfStop Stops left)';
        break;
      case 'zh':
        break;
    }
    TextSpan sp = TextSpan(style: TextStyle(color: Theme.of(context).backgroundColor == Colors.white ? Colors.grey : Colors.white, fontSize: 12, fontFamily: "Godo"), text: _stopString);
    TextPainter tp = TextPainter(text: sp, textDirection: TextDirection.ltr);
    tp.layout();
    Offset location = Offset(offset.dx, offset.dy - tp.height * .5);
    tp.paint(canvas, location);
  }

  void drawSeat(Canvas canvas, Offset offset, int seats, Color lineColor, BuildContext context) {
    String _seatString;
    switch(prefManager.getString("localeCode", defaultValue: "ko_KR").getValue()){
      case 'ko_KR':
        _seatString = '$seats석';
        break;
      case 'en_US':
        _seatString = 'Seats: $seats';
        break;
      case 'zh':
        break;
    }

    TextSpan sp = TextSpan(style: TextStyle(color: lineColor, fontSize: 12, fontFamily: "Godo"), text: _seatString);
    TextPainter tp = TextPainter(text: sp, textDirection: TextDirection.ltr);
    tp.layout();
    Offset location = Offset(offset.dx, offset.dy - tp.height * .5);
    tp.paint(canvas, location);
  }

  String _getArrivalTime(String time){
    String _timeString;
    switch(prefManager.getString("localeCode", defaultValue: "ko_KR").getValue()){
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

  String _getTime(int time){
    String _timeString;
    switch(prefManager.getString("localeCode", defaultValue: "ko_KR").getValue()){
      case 'ko_KR':
        _timeString = '$time 분';
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

    final _inBoxColor = Paint()
      ..color = Theme.of(context).backgroundColor == Colors.white ? Colors.grey : Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.0;

    final _boxColor = Paint()
      ..color = Colors.grey.withOpacity(0.6)
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

    List<BusInfoRealtime> realtimeList = data['realtime'];
    List<BusInfoTimetable> timetableList = data['timetable'];

      if(realtimeList.length >= 2){
        drawRemainedTime(canvas, Offset(15, 10), _getTime(realtimeList.elementAt(0).time), context);
        if(prefManager.getString("localeCode", defaultValue: "ko_KR").getValue() == "ko_KR"){
          drawInfo(canvas, Offset(52.5, 10), realtimeList.elementAt(0).location, context);
          drawSeat(canvas, Offset(105, 10), realtimeList.elementAt(0).seats, lineColor, context);
        } else {
          drawInfo(canvas, Offset(100, 10), realtimeList.elementAt(0).location, context);
        }
        drawRemainedTime(canvas, Offset(15, 35), _getTime(realtimeList.elementAt(1).time), context);
        if(prefManager.getString("localeCode", defaultValue: "ko_KR").getValue() == "ko_KR"){
          drawInfo(canvas, Offset(52.5, 35), realtimeList.elementAt(1).location, context);
          drawSeat(canvas, Offset(105, 35), realtimeList.elementAt(1).seats, lineColor, context);
        } else {
          drawInfo(canvas, Offset(100, 35), realtimeList.elementAt(1).location, context);
        }
      } else if(realtimeList.length == 1){
        drawRemainedTime(canvas, Offset(15, 10), _getTime(realtimeList.elementAt(0).time), context);
        if(realtimeList.elementAt(0).seats != -1){
          if(prefManager.getString("localeCode", defaultValue: "ko_KR").getValue() == "ko_KR"){
            canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(50, 2, 82.5, 16), Radius.circular(1.5)), _boxColor);
            canvas.drawRect(Rect.fromLTWH(51, 3, 80.5, 14), _inBoxColor);
            drawInfo(canvas, Offset(52.5, 10), realtimeList.elementAt(0).location, context);
            drawSeat(canvas, Offset(105, 10), realtimeList.elementAt(0).seats, lineColor, context);
          } else {
            canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(50, 2, 47.5, 16), Radius.circular(1.5)), _line);
            canvas.drawRect(Rect.fromLTWH(51, 3, 45.5, 14), _inBoxColor);
            drawInfo(canvas, Offset(52.5, 10), realtimeList.elementAt(0).location, context);
          }
        } else {
          drawInfo(canvas, Offset(100, 10), realtimeList.elementAt(0).location, context);
        }
        if(timetableList.isNotEmpty){
          drawRemainedTime(canvas, Offset(15, 35), _getArrivalTime(timetableList.elementAt(0).time), context);
        } else {
          if(timeTableOffered) {
            drawRemainedTime(canvas, Offset(15, 35), TranslationManager.of(context).trans("last_bus"), context);
          } else {
            drawRemainedTime(canvas, Offset(15, 35), TranslationManager.of(context).trans("timetable_not_offered"), context);
          }
        }
      } else if (!timeTableOffered){
        drawRemainedTime(canvas, Offset(15, 10), TranslationManager.of(context).trans("timetable_not_offered"), context);
      } else if(timetableList.length >= 2) {
        drawRemainedTime(canvas, Offset(15, 10), _getArrivalTime(timetableList.elementAt(0).time), context);
        drawRemainedTime(canvas, Offset(15, 35), _getArrivalTime(timetableList.elementAt(1).time), context);
      } else if (timetableList.length == 1){
        drawRemainedTime(canvas, Offset(15, 10), _getArrivalTime(timetableList.elementAt(0).time), context);
        drawRemainedTime(canvas, Offset(15, 35), TranslationManager.of(context).trans("last_bus"), context);
      } else {
        drawRemainedTime(canvas, Offset(15, 10), TranslationManager.of(context).trans("out_of_service"), context);
      }
  }

  @override
  bool shouldRepaint(covariant BusCardPaint oldDelegate) {
    if(oldDelegate.data != this.data){
      return true;
    } else{
      return false;
    }
  }
}