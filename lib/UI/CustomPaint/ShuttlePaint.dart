import 'package:flutter/material.dart';
import 'package:flutter_app_hyuabot_v2/Config/Common.dart';
import 'package:flutter_app_hyuabot_v2/Model/Shuttle.dart';

class ShuttleCardPaint extends CustomPainter{
  final List<dynamic> timetableList;
  final ShuttleStopDepartureInfo data;
  final Color lineColor;
  final BuildContext context;

  ShuttleCardPaint(this.timetableList, this.data, this.lineColor, this.context);

  void drawRemainedTime(Canvas canvas, Offset offset, String text, BuildContext context) {
    TextSpan sp = TextSpan(style: TextStyle(color: Theme.of(context).backgroundColor == Colors.white ? Colors.black : Colors.white, fontSize: 12, fontFamily: 'Godo'), text: text);
    TextPainter tp = TextPainter(text: sp, textDirection: TextDirection.ltr);
    tp.layout();
    Offset location = Offset(offset.dx, offset.dy - tp.height * .5);
    tp.paint(canvas, location);
  }

  String _getDirection(String time, ShuttleStopDepartureInfo data){
    if(data.shuttleListTerminal.contains(time) || data.shuttleListStation.contains(time)){
      return '직행';
    } else {
      return '순환';
    }
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
    DateTime now = DateTime.now();

    if(timetableList.length >= 2){
      status = '${getTimeFromString(timetableList.elementAt(0), now).difference(now).inMinutes} 분 (${_getDirection(timetableList.elementAt(0), data)})';
      drawRemainedTime(canvas, Offset(25, 10), status, context);
      status = '${getTimeFromString(timetableList.elementAt(1), now).difference(now).inMinutes} 분 (${_getDirection(timetableList.elementAt(0), data)})';
      drawRemainedTime(canvas, Offset(25, 35), status, context);
    } else if(timetableList.length == 1){
      status = '${getTimeFromString(timetableList.elementAt(0), now).difference(now).inMinutes} 분 (${_getDirection(timetableList.elementAt(0), data)})';
      drawRemainedTime(canvas, Offset(25, 10), status, context);
      drawRemainedTime(canvas, Offset(25, 35), '막차', context);
    } else {
      drawRemainedTime(canvas, Offset(25, 10), '운행 종료', context);
    }
  }

  @override
  bool shouldRepaint(covariant ShuttleCardPaint oldDelegate) {
    if(oldDelegate.data != this.data){
      return true;
    } else{
      return false;
    }
  }
}