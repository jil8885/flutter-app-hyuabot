import 'package:flutter/material.dart';
import 'package:flutter_app_hyuabot_v2/Config/Common.dart';
import 'package:flutter_app_hyuabot_v2/Model/Metro.dart';

class MetroRealtimeCardPaint extends CustomPainter{
  final List<MetroRealtimeInfo> data;
  final Color lineColor;
  final BuildContext context;

  MetroRealtimeCardPaint(this.data, this.lineColor, this.context);

  void drawRemainedTime(Canvas canvas, Offset offset, String text, BuildContext context) {
    TextSpan sp = TextSpan(style: TextStyle(color: Theme.of(context).backgroundColor == Colors.white ? Colors.black : Colors.white, fontSize: 12, fontFamily: 'Godo'), text: text);
    TextPainter tp = TextPainter(text: sp, textDirection: TextDirection.ltr);
    tp.layout();
    Offset location = Offset(offset.dx, offset.dy - tp.height * .5);
    tp.paint(canvas, location);
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
      canvas.drawLine(Offset(10, _start), Offset(10, _start + _dashSpace), _line);
      _start += space;
    }

    canvas.drawCircle(Offset(10, 10), 5.0, _colorPaint);
    canvas.drawCircle(Offset(10, 35), 5.0, _line);
    canvas.drawCircle(Offset(10, 35), 3.0, _white);

    String status;
    if(data.length >= 2){
      if(data.elementAt(0).currentStatus.toString().contains("전역")){
        status = data.elementAt(0).currentStatus;
      } else if(data.elementAt(0).currentStatus.toString() == "운행중"){
        status = data.elementAt(0).currentStation;
      } else {
        status = '${data.elementAt(0).currentStation} ${data.elementAt(0).currentStatus}';
      }

      drawRemainedTime(canvas, Offset(25, 10), '${data.elementAt(0).terminalStation}행 ${data.elementAt(0).remainedTime.toInt()}분 ($status)', context);

      if(data.elementAt(1).currentStatus.toString().contains("전역")){
        status = data.elementAt(1).currentStatus;
      } else if(data.elementAt(1).currentStatus.toString() == "운행중"){
        status = data.elementAt(1).currentStation;
      } else {
        status = '${data.elementAt(1).currentStation} ${data.elementAt(1).currentStatus}';
      }

      drawRemainedTime(canvas, Offset(25, 35), '${data.elementAt(1).terminalStation}행 ${data.elementAt(1).remainedTime.toInt()}분 ($status)', context);
    } else if(data.length == 1){
      if(data.elementAt(0).currentStatus.toString().contains("전역")){
        status = data.elementAt(0).currentStatus;
      } else if(data.elementAt(0).currentStatus.toString() == "운행중"){
        status = data.elementAt(0).currentStation;
      } else {
        status = '${data.elementAt(0).currentStation} ${data.elementAt(0).currentStatus}';
      }
      drawRemainedTime(canvas, Offset(25, 10), '${data.elementAt(0).terminalStation}행 ${data.elementAt(0).remainedTime.toInt()}분 ($status)', context);
      drawRemainedTime(canvas, Offset(25, 35), '정보 없음', context);
    } else {
      drawRemainedTime(canvas, Offset(25, 10), '운행 종료', context);
    }
  }

  @override
  bool shouldRepaint(covariant MetroRealtimeCardPaint oldDelegate) {
    if(oldDelegate.data != this.data){
      return true;
    } else{
      return false;
    }
  }
}

class MetroTimeTableCardPaint extends CustomPainter{
  final List<MetroTimeTableInfo> data;
  final Color lineColor;
  final BuildContext context;

  MetroTimeTableCardPaint(this.data, this.lineColor, this.context);

  void drawRemainedTime(Canvas canvas, Offset offset, String text, BuildContext context) {
    TextSpan sp = TextSpan(style: TextStyle(color: Theme.of(context).backgroundColor == Colors.white ? Colors.black : Colors.white, fontSize: 12, fontFamily: 'Godo'), text: text);
    TextPainter tp = TextPainter(text: sp, textDirection: TextDirection.ltr);
    tp.layout();
    Offset location = Offset(offset.dx, offset.dy - tp.height * .5);
    tp.paint(canvas, location);
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
      canvas.drawLine(Offset(10, _start), Offset(10, _start + _dashSpace), _line);
      _start += space;
    }

    canvas.drawCircle(Offset(10, 10), 5.0, _colorPaint);
    canvas.drawCircle(Offset(10, 35), 5.0, _line);
    canvas.drawCircle(Offset(10, 35), 3.0, _white);

    DateTime now = DateTime.now();
    if(data.length >= 2){
      drawRemainedTime(canvas, Offset(25, 10), '${data.elementAt(0).terminalStation}행 ${getTimeFromString(data.elementAt(0).arrivalTime.toString(), now).difference(now).inMinutes}분', context);
      drawRemainedTime(canvas, Offset(25, 35), '${data.elementAt(1).terminalStation}행 ${getTimeFromString(data.elementAt(1).arrivalTime.toString(), now).difference(now).inMinutes}분', context);
    } else if(data.length == 1){
      drawRemainedTime(canvas, Offset(25, 10), '${data.elementAt(0).terminalStation}행 ${getTimeFromString(data.elementAt(0).arrivalTime.toString(), now).difference(now).inMinutes}분', context);
    } else {
      drawRemainedTime(canvas, Offset(25, 10), '운행 종료', context);
    }
  }

  @override
  bool shouldRepaint(covariant MetroTimeTableCardPaint oldDelegate) {
    if(oldDelegate.data != this.data){
      return true;
    } else{
      return false;
    }
  }
}