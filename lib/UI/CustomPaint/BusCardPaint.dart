import 'package:flutter/material.dart';
import 'package:flutter_app_hyuabot_v2/Model/Bus.dart';

class BusCardPaint extends CustomPainter{
  final Map<String, dynamic> data;
  final Color lineColor;
  final BuildContext context;
  bool timeTableOffered;

  BusCardPaint(this.data, this.lineColor, this.context, this.timeTableOffered);

  void drawRemainedTime(Canvas canvas, Offset offset, String text, BuildContext context) {
    TextSpan sp = TextSpan(style: TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Godo'), text: text);
    TextPainter tp = TextPainter(text: sp, textDirection: TextDirection.ltr);
    tp.layout();
    Offset location = Offset(offset.dx, offset.dy - tp.height * .5);
    tp.paint(canvas, location);
  }

  void drawInfo(Canvas canvas, Offset offset, int numOfStop, BuildContext context) {
    TextSpan sp = TextSpan(style: TextStyle(color: Colors.grey, fontSize: 12, fontFamily: 'Godo'), text: '$numOfStop번째 전');
    TextPainter tp = TextPainter(text: sp, textDirection: TextDirection.ltr);
    tp.layout();
    Offset location = Offset(offset.dx, offset.dy - tp.height * .5);
    tp.paint(canvas, location);
  }

  void drawSeat(Canvas canvas, Offset offset, int seats, Color lineColor, BuildContext context) {
    TextSpan sp = TextSpan(style: TextStyle(color: lineColor, fontSize: 12, fontFamily: 'Godo'), text: '$seats석');
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

    final _boxColor = Paint()
      ..color = Colors.grey.withOpacity(0.6)
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

    List<BusInfoRealtime> realtimeList = data['realtime'];
    List<BusInfoTimetable> timetableList = data['timetable'];

      if(realtimeList.length >= 2){
        drawRemainedTime(canvas, Offset(15, 10), '${realtimeList.elementAt(0).time}분', context);
        drawRemainedTime(canvas, Offset(15, 35), '${realtimeList.elementAt(1).time}분', context);
      } else if(realtimeList.length == 1){
        drawRemainedTime(canvas, Offset(15, 10), '${realtimeList.elementAt(0).time}분', context);
        if(realtimeList.elementAt(0).seats != -1){
          canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(50, 2, 82.5, 16), Radius.circular(1.5)), _boxColor);
          canvas.drawRect(Rect.fromLTWH(51, 3, 80.5, 14), _white);
          drawInfo(canvas, Offset(52.5, 10), realtimeList.elementAt(0).location, context);
          drawSeat(canvas, Offset(105, 10), realtimeList.elementAt(0).seats, lineColor, context);
        } else {
          canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(50, 2, 47.5, 16), Radius.circular(1.5)), _line);
          canvas.drawRect(Rect.fromLTWH(51, 3, 45.5, 14), _white);
          drawInfo(canvas, Offset(52.5, 10), realtimeList.elementAt(0).location, context);
        }
        if(timetableList.isNotEmpty){
          drawRemainedTime(canvas, Offset(15, 35), '${timetableList.elementAt(0).time} 출발', context);
        } else {
          if(timeTableOffered) {
            drawRemainedTime(canvas, Offset(15, 35), '막차입니다.', context);
          } else {
            drawRemainedTime(canvas, Offset(15, 35), '시간표 미제공', context);
          }
        }
      } else if (!timeTableOffered){
        drawRemainedTime(canvas, Offset(15, 10), '시간표 미제공', context);
      } else if(timetableList.length >= 2) {
        drawRemainedTime(canvas, Offset(15, 10), '${timetableList.elementAt(0).time} 출발', context);
        drawRemainedTime(canvas, Offset(15, 35), '${timetableList.elementAt(1).time} 출발', context);
      } else if (timetableList.length == 1){
        drawRemainedTime(canvas, Offset(15, 10), '${timetableList.elementAt(0).time} 출발', context);
        drawRemainedTime(canvas, Offset(15, 35), '막차입니다.', context);
      } else {
        drawRemainedTime(canvas, Offset(15, 10), '운행 종료', context);
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