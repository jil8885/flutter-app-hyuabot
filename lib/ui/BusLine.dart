import 'package:chatbot/model/Bus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BusLine extends CustomPainter{
  final List<String> stopList;
  final BusInfoRealtime realtimeInfo;
  final List<BusInfoTimetable> timetableInfo;
  final String terminalStop;

  BusLine(this.stopList, this.realtimeInfo, this.timetableInfo, {this.terminalStop=""});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.0;

    Paint commingBus = Paint()
      ..color = Colors.green
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1.5;

    Offset start = Offset(160, 20);
    Offset end = Offset(160, size.height - 20);
    Offset arrowEnd = Offset(168, size.height - 28);
    canvas.drawLine(start, end, paint);
    canvas.drawLine(end, arrowEnd, paint);

    int length = this.stopList.length;
    for(int i=0; i<length; i++){
      canvas.drawCircle(Offset(160, 60 + (size.height - 120) / (length - 1) * i), 4, paint);
      TextSpan sp = TextSpan(style: TextStyle(color: Colors.white), text: stopList[(length - 1) - i]);
      TextPainter tp = TextPainter(text: sp, textDirection: TextDirection.ltr, textAlign: TextAlign.right);
      tp.layout();
      tp.paint(canvas, Offset(90 - tp.width * 0.5, 60 + (size.height - 120) / (length - 1) * i - tp.height * 0.5));
    }

    int location = this.realtimeInfo.location;
    if(location != -1){
      String resultString = "";
      if(this.realtimeInfo.seats == -1){
        resultString = this.realtimeInfo.location.toString() + "전 정류장 / " + this.realtimeInfo.time.toString() + "분 후 도착";
      } else{
        resultString = this.realtimeInfo.location.toString() + "전 정류장 / " + this.realtimeInfo.time.toString() + "분 후 도착(" + this.realtimeInfo.seats.toString() + "석)";
      }
      if(location < length){
        canvas.drawCircle(Offset(160, 60 + (size.height - 120) / (length - 1) * (length - location - 0.5)), 4, commingBus);
        TextSpan sp = TextSpan(style: TextStyle(color: Colors.black), text: resultString);
        TextPainter tp = TextPainter(text: sp, textDirection: TextDirection.ltr, textAlign: TextAlign.right);
        tp.layout();
        canvas.drawRRect(RRect.fromRectAndCorners(Rect.fromLTWH(175, 58 + (size.height - 120) / (length - 1) * (length - location - 0.5) - tp.height * 0.5, tp.width + 10, tp.height  + 4),
            bottomLeft: Radius.circular(4), bottomRight: Radius.circular(4), topLeft: Radius.circular(4), topRight: Radius.circular(4)),
            paint);
        tp.paint(canvas, Offset(180, 60 + (size.height - 120) / (length - 1) * (length - location - 0.5) - tp.height * 0.5));
      } else{
        canvas.drawCircle(Offset(160, 20), 4, commingBus);
        TextSpan sp = TextSpan(style: TextStyle(color: Colors.black), text: resultString);
        TextPainter tp = TextPainter(text: sp, textDirection: TextDirection.ltr, textAlign: TextAlign.right);
        tp.layout();
        canvas.drawRRect(RRect.fromRectAndCorners(Rect.fromLTWH(175, 18 - tp.height * 0.5, tp.width + 10, tp.height  + 4),
            bottomLeft: Radius.circular(4), bottomRight: Radius.circular(4), topLeft: Radius.circular(4), topRight: Radius.circular(4)),
            paint);
        tp.paint(canvas, Offset(180, 20 - tp.height * 0.5));
      }
    } else{
      if(this.timetableInfo.isNotEmpty){
        String nextDeparture = this.timetableInfo[0].time;
        canvas.drawCircle(Offset(160, 20), 4, commingBus);
        TextSpan sp = TextSpan(style: TextStyle(color: Colors.black), text: terminalStop + " " + nextDeparture.replaceFirst(":", "시") + "분 출발");
        TextPainter tp = TextPainter(text: sp, textDirection: TextDirection.ltr, textAlign: TextAlign.right);
        tp.layout();
        canvas.drawRRect(RRect.fromRectAndCorners(Rect.fromLTWH(175, 18 - tp.height * 0.5, tp.width + 10, tp.height  + 4),
            bottomLeft: Radius.circular(4), bottomRight: Radius.circular(4), topLeft: Radius.circular(4), topRight: Radius.circular(4)),
            paint);
        tp.paint(canvas, Offset(180, 20 - tp.height * 0.5));
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
