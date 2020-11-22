import 'package:chatbot/config/Common.dart';
import 'package:chatbot/model/Bus.dart';
import 'package:flutter/material.dart';

class BusLanes extends CustomPainter {
  final BuildContext context;
  final List stopList;
  final List<BusInfoRealtime> realtimeList;
  final List<BusInfoTimetable> timetableList;
  final String terminalStop;

  BusLanes(this.context, this.stopList, this.realtimeList, this.timetableList, this.terminalStop);
  @override
  void paint(Canvas canvas, Size size) {

    final white = Paint()
      ..color = Colors.white
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4.0;

    final transparent = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4.0;

    final color = Paint()
      ..color = Color.fromRGBO(153, 255, 0, 1)
      ..style = PaintingStyle.fill;
    // 노선
    canvas.drawLine(Offset(size.width / 2.5, 40), Offset(size.width / 2.5, size.height - 40), transparent);
    
    // 정류장 표지
    for(int i = 0; i < this.stopList.length; i++){
      canvas.drawCircle(Offset(size.width / 2.5, 40 + (size.height - 80) * i / (this.stopList.length - 1)), 4.0, white);
      drawText(canvas, size, stopList[i], size.width / 2.5 - 60, 40 + (size.height - 80) * i / (this.stopList.length - 1));
    }
    
    // 실시간 정보
    for(BusInfoRealtime info in this.realtimeList){
      String result = "${info.time}분 후 도착(${info.location}전)";
      if(info.location >= this.stopList.length){
        drawInfo(context, canvas, size, "$result", size.width / 2.5 + 30, 40);
        drawBus(canvas, size.width / 2.5, 40, color);
        if(info.seats != -1){
          drawInfo(context, canvas, size, "${info.seats}석", size.width / 2.5 + 165, 40);
        }
      } else {
        drawInfo(context, canvas, size, "$result", size.width / 2.5 + 30, size.height - 40 - (size.height - 80) * (info.location - 0.5) / (this.stopList.length - 1));
        drawBus(canvas, size.width / 2.5, size.height - 40 - (size.height - 80) * (info.location - 0.5) / (this.stopList.length - 1), color);
        if(info.seats != -1){
          drawInfo(context, canvas, size, "${info.seats}석", size.width / 2.5 + 165, size.height - 40 - (size.height - 80) * (info.location - 0.5) / (this.stopList.length - 1));
        }
      }
    }
    
    // 시간표 정보
    if(this.realtimeList.isEmpty && this.timetableList.isNotEmpty){
      BusInfoTimetable info = this.timetableList[0];
      drawInfo(context, canvas, size, "${this.terminalStop} ${info.time} 출발", size.width / 2.5 + 30, 40);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  void drawBus(Canvas canvas, double dx, double dy, Paint paint){
    canvas.drawCircle(Offset(dx, dy), 6.0 , paint);
  }

  void drawText(Canvas canvas, Size size, String text, double dx, double dy){
    TextSpan sp = TextSpan(style: TextStyle(fontSize: 11, fontFamily: "Noto Sans KR", color: Colors.white, fontWeight: FontWeight.bold), text: text);
    TextPainter tp = TextPainter(text: sp, textDirection: TextDirection.ltr);
    tp.layout();
    Offset offset = Offset(dx - tp.width / 2, dy - tp.height / 2);
    tp.paint(canvas, offset);
  }

  void drawInfo(BuildContext context, Canvas canvas, Size size, String text, double dx, double dy){
    final white = Paint()
      ..color = Colors.white
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4.0;

    TextSpan sp = TextSpan(style: TextStyle(fontSize: 14, fontFamily: "Noto Sans KR", color: Theme.of(context).accentColor, fontWeight: FontWeight.bold), text: text);
    TextPainter tp = TextPainter(text: sp, textDirection: TextDirection.ltr);
    tp.layout();
    Offset offset = Offset(dx , dy - tp.height / 2);
    final rect = Rect.fromLTWH(dx - 10, dy - tp.height / 2 - 5, tp.width + 20, tp.height + 10);
    canvas.drawRRect(RRect.fromRectAndRadius(rect, Radius.circular(40)), white);
    tp.paint(canvas, offset);
  }
}
