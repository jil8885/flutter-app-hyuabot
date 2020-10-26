import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MetroLineRight extends CustomPainter{
  final List<String> stationList;
  MetroLineRight(this.stationList);

  @override
  void paint(Canvas canvas, Size size) {
    Paint line = Paint()
      ..color = Colors.white
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.0;

    Paint circle = Paint()
      ..color = Colors.white
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3;


    Offset start = Offset(40, size.height / 3);
    Offset end = Offset(size.width - 40, size.height / 3);
    Offset arrowEnd = Offset(size.width - 50, size.height / 3 - 10);
    canvas.drawLine(start, end, line);
    canvas.drawLine(end, arrowEnd, line);

    for(int i=0; i<5; i++){
      canvas.drawCircle(Offset(60 + (size.width - 120) / 4 * i, size.height / 3), 4, circle);
      TextSpan sp = TextSpan(style: TextStyle(color: Colors.white), text: stationList[4 - i]);
      TextPainter tp = TextPainter(text: sp, textDirection: TextDirection.ltr);
      tp.layout();
      tp.paint(canvas, Offset(48 + (size.width - 120) / 4 * i, size.height / 3 + 10));
    }

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class MetroLineLeft extends CustomPainter{
  final List<String> stationList;
  MetroLineLeft(this.stationList);

  @override
  void paint(Canvas canvas, Size size) {
    Paint line = Paint()
      ..color = Colors.white
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.0;

    Paint circle = Paint()
      ..color = Colors.white
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3;


    Offset start = Offset(40, size.height / 3);
    Offset end = Offset(size.width - 40, size.height / 3);
    Offset arrowEnd = Offset(50, size.height / 3 - 10);
    canvas.drawLine(start, end, line);
    canvas.drawLine(start, arrowEnd, line);

    for(int i=0; i<5; i++){
      canvas.drawCircle(Offset(60 + (size.width - 120) / 4 * i, size.height / 3), 4, circle);
      TextSpan sp = TextSpan(style: TextStyle(color: Colors.white), text: stationList[i]);
      TextPainter tp = TextPainter(text: sp, textDirection: TextDirection.ltr);
      tp.layout();
      tp.paint(canvas, Offset(48 + (size.width - 120) / 4 * i, size.height / 3 + 10));
    }

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}