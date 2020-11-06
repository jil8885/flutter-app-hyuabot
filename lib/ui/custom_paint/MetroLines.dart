import 'package:flutter/material.dart';

class MetroLanesRealtime extends CustomPainter {
  final isRight;
  final lineColor;
  final stationList;

  MetroLanesRealtime(this.isRight, this.lineColor, this.stationList);
  @override
  void paint(Canvas canvas, Size size) {
    final white = Paint()
      ..color = Colors.white
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4.0;

    final subBox = Paint()
      ..color = Color.fromRGBO(8, 43, 66, 1)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4.0;

    final metroLine = Paint()
      ..color = lineColor
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4.0;

    // 주 사각형
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(20, 10, size.width - 40, size.height - 20), Radius.circular(10)), white);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(20, 10 + (size.height - 20)*.6, size.width - 40, (size.height - 20)*.4), Radius.circular(10)), subBox);
  
    // 화살표(왼쪽/오른쪽)
    canvas.drawLine(Offset(40, size.height / 3), Offset(size.width - 40, size.height / 3), metroLine);
    if(isRight){
      canvas.drawLine(Offset(size.width - 40, size.height / 3), Offset(size.width - 50, size.height / 3 - 10), metroLine);
      canvas.drawLine(Offset(size.width - 40, size.height / 3), Offset(size.width - 50, size.height / 3 + 10), metroLine);
    } else{
      canvas.drawLine(Offset(40, size.height / 3), Offset(50, size.height / 3 - 10), metroLine);
      canvas.drawLine(Offset(40, size.height / 3), Offset(50, size.height / 3 + 10), metroLine);
    }
    
    // 각 역 표시
    for(int i=0; i<stationList.length; i++){
      canvas.drawCircle(Offset(70 + (size.width - 140) * (i / (stationList.length - 1)), size.height / 3), 4.0, metroLine);
      TextSpan sp = TextSpan(style: TextStyle(fontSize: 11, fontFamily: "Noto Sans KR", color: Colors.black), text: stationList[i]);
      TextPainter tp = TextPainter(text: sp, textDirection: TextDirection.ltr);
      tp.layout();
      double dx = 70 + (size.width - 140) * (i / (stationList.length - 1)) - tp.width / 2;
      double dy = size.height / 2.25 - tp.height / 2;
      Offset offset = Offset(dx, dy);
      tp.paint(canvas, offset);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}