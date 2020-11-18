import 'package:chatbot/config/common.dart';
import 'package:chatbot/model/Bus.dart';
import 'package:flutter/material.dart';

class BusLanes extends CustomPainter {
  final List stopList;
  final List<BusInfoRealtime> realtimeList;
  final List<BusInfoTimetable> timetableList;
  final String terminalStop;

  BusLanes(this.stopList, this.realtimeList, this.timetableList, this.terminalStop);
  @override
  void paint(Canvas canvas, Size size) {

    final white = Paint()
      ..color = Colors.white
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4.0;

    final color = Paint()
      ..color = Color.fromRGBO(153, 255, 0, 1)
      ..style = PaintingStyle.fill;
    // 노선
    canvas.drawLine(Offset(size.width / 2.5, 40), Offset(size.width / 2.5, size.height - 40), white);
    
    // 정류장 표지
    for(int i = 0; i < this.stopList.length; i++){
      canvas.drawCircle(Offset(size.width / 2.5, 40 + (size.height - 80) * i / (this.stopList.length - 1)), 6.0, white);
      drawText(canvas, size, stopList[i], size.width / 2.5 - 60, 40 + (size.height - 80) * i / (this.stopList.length - 1));
    }
    
    // 실시간 정보
    for(BusInfoRealtime info in this.realtimeList){
      String result;
      if(info.seats == -1){
        result = "${info.location}전 정류장 / ${info.time}분 후 도착";
      } else {
        result = "${info.location}전 정류장 / ${info.time}분 후 도착(${info.seats}석)";
      }
      if(info.location >= this.stopList.length){
        drawInfo(canvas, size, "$result", size.width / 2.5 + 120, 40);
        drawBus(canvas, size.width / 2.5, 40, color);
      } else {
        drawInfo(canvas, size, "$result", size.width / 2.5 + 120, size.height - 40 - (size.height - 80) * (info.location - 0.5) / (this.stopList.length - 1));
        drawBus(canvas, size.width / 2.5, size.height - 40 - (size.height - 80) * (info.location - 0.5) / (this.stopList.length - 1), color);
      }
    }
    
    // 시간표 정보
    if(this.realtimeList.isEmpty && this.timetableList.isNotEmpty){
      BusInfoTimetable info = this.timetableList[0];
      List<String> time = info.time.split(":");
      drawInfo(canvas, size, "${this.terminalStop} ${time[0]}시${time[1]}분 출발 예정", size.width / 2.5 + 120, 40);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  void drawBus(Canvas canvas, double dx, double dy, Paint paint){
    canvas.drawCircle(Offset(dx, dy), 8.0 , paint);
  }

  void drawText(Canvas canvas, Size size, String text, double dx, double dy){
    TextSpan sp = TextSpan(style: TextStyle(fontSize: 11, fontFamily: "Noto Sans KR", color: Colors.white, fontWeight: FontWeight.bold), text: text);
    TextPainter tp = TextPainter(text: sp, textDirection: TextDirection.ltr);
    tp.layout();
    Offset offset = Offset(dx - tp.width / 2, dy - tp.height / 2);
    tp.paint(canvas, offset);
  }

  void drawInfo(Canvas canvas, Size size, String text, double dx, double dy){
    TextSpan sp = TextSpan(style: TextStyle(fontSize: 14, fontFamily: "Noto Sans KR", color: Colors.white, fontWeight: FontWeight.bold), text: text);
    TextPainter tp = TextPainter(text: sp, textDirection: TextDirection.ltr);
    tp.layout();
    Offset offset = Offset(dx - tp.width / 2, dy - tp.height / 2);
    tp.paint(canvas, offset);
  }
}
