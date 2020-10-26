import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BusLaneCycle extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size) {
    List<String> stopList = ["\n기숙사", "\n셔틀콕", "\n한대앞", "\n예술인", "셔틀콕\n건너편"];

    Paint line = Paint()
        ..color = Colors.white
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 2.0;

    Paint circle = Paint()
      ..color = Colors.white
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5;


    Offset start = Offset(40, size.height / 2.5);
    Offset end = Offset(size.width - 40, size.height / 2.5);
    canvas.drawLine(start, end, line);

    for(int i=0; i<5; i++){
      canvas.drawCircle(Offset(40 + (size.width - 80) / 4 * i, size.height / 2.5), 9, circle);
      TextSpan sp = TextSpan(style: TextStyle(color: Colors.white), text: stopList[i]);
      TextPainter tp = TextPainter(text: sp, textDirection: TextDirection.ltr);
      tp.layout();
      tp.paint(canvas, Offset(20 + (size.width - 80) / 4 * i, size.height / 2.5 - 45));
    }

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class BusLaneDirectStation extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size) {
    List<String> stopList = ["\n기숙사", "\n셔틀콕", "\n한대앞", "셔틀콕\n건너편"];

    Paint line = Paint()
      ..color = Colors.white
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.0;

    Paint circle = Paint()
      ..color = Colors.white
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5;


    Offset start = Offset(40, size.height / 2.5);
    Offset end = Offset(size.width - 40, size.height / 2.5);
    canvas.drawLine(start, end, line);

    for(int i=0; i<4; i++){
      canvas.drawCircle(Offset(40 + (size.width - 80) / 3 * i, size.height / 2.5), 9, circle);
      TextSpan sp = TextSpan(style: TextStyle(color: Colors.white), text: stopList[i]);
      TextPainter tp = TextPainter(text: sp, textDirection: TextDirection.ltr);
      tp.layout();
      tp.paint(canvas, Offset(20 + (size.width - 80) / 3 * i, size.height / 2.5 - 45));
    }

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class BusLaneDirectTerminal extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size) {
    List<String> stopList = ["\n기숙사", "\n셔틀콕", "\n예술인", "셔틀콕\n건너편"];

    Paint line = Paint()
      ..color = Colors.white
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.0;

    Paint circle = Paint()
      ..color = Colors.white
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5;


    Offset start = Offset(40, size.height / 2.5);
    Offset end = Offset(size.width - 40, size.height / 2.5);
    canvas.drawLine(start, end, line);

    for(int i=0; i<4; i++){
      canvas.drawCircle(Offset(40 + (size.width - 80) / 3 * i, size.height / 2.5), 9, circle);
      TextSpan sp = TextSpan(style: TextStyle(color: Colors.white), text: stopList[i]);
      TextPainter tp = TextPainter(text: sp, textDirection: TextDirection.ltr);
      tp.layout();
      tp.paint(canvas, Offset(20 + (size.width - 80) / 3 * i, size.height / 2.5 - 45));
    }

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}