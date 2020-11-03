import 'dart:io';

import 'package:chatbot/config/common.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';

class ShuttleLanes extends CustomPainter{
  final String label;
  final BuildContext context;
  final Map<String, List<String>> data;
  final ui.Image icon;
  ShuttleLanes(this.label, this.context, this.data, this.icon);

  @override
  void paint(Canvas canvas, Size size){
    DateTime current = DateTime.now();
    final paint = Paint()
      ..color = Colors.white
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4.0;

    final color = Paint()
      ..color = Colors.orange
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4.0;

    final radius = 4.5;

    // 도형 그리기
    canvas.drawLine(Offset(90, size.height / 3), Offset(350, size.height / 3), paint);
    drawLabel(canvas, size, label, context);
    canvas.drawCircle(Offset(90, size.height / 3), radius, paint);
    canvas.drawCircle(Offset(155, size.height / 3), radius, paint);
    if (!this.label.contains("예술인")) {
      canvas.drawCircle(Offset(220, size.height / 3), radius, paint);
    }
    if (!this.label.contains("한대앞")) {
      canvas.drawCircle(Offset(285, size.height / 3), radius, paint);
    }
    canvas.drawCircle(Offset(355, size.height / 3), radius, paint);


    String result;
    List<DateTime> timeTable;

    timeTable = data["Residence"].map((e) => getTimeFromString(e, current)).toList();
    if(timeTable.length > 0){
      Duration diff = timeTable[0].difference(current);
      result = "${diff.inMinutes}분 후\n";
      drawText(canvas, 90, size.height * .66, result.trim(), context);
    }

    timeTable = data["Shuttlecock_O"].map((e) => getTimeFromString(e, current)).toList();
    if(timeTable.length > 0){
      Duration diff = timeTable[0].difference(current);
      result = "${diff.inMinutes}분 후\n";
      drawText(canvas, 155, size.height * .66, result.trim(), context);
    }

    timeTable = data["Subway"].map((e) => getTimeFromString(e, current)).toList();
    if(timeTable.length > 0){
      Duration diff = timeTable[0].difference(current);
      result = "${diff.inMinutes}분 후\n";
      drawText(canvas, 220, size.height * .66, result.trim(), context);
    }

    timeTable = data["YesulIn"].map((e) => getTimeFromString(e, current)).toList();
    if(timeTable.length > 0){
      Duration diff = timeTable[0].difference(current);
      result = "${diff.inMinutes}분 후\n";
      drawText(canvas, 285, size.height * .66, result.trim(), context);
    }

    timeTable = data["Shuttlecock_I"].map((e) => getTimeFromString(e, current)).toList();
    if(timeTable.length > 0){
      Duration diff = timeTable[0].difference(current);
      result = "${diff.inMinutes}분 후\n";
      drawText(canvas, 350, size.height * .66, result.trim(), context);
    }



    if(label.contains("한대앞")){
      timeTable = data["Subway"].map((e) => getTimeFromString(e, current)).toList();
      canvas.drawImage(icon, Offset(340, size.height / 3 - 15), paint);
      return;
    } else if(label.contains("예술인")){
      timeTable = data["YesulIn"].map((e) => getTimeFromString(e, current)).toList();
      return;
    } else{
      timeTable = data["Shuttlecock_I"].map((e) => getTimeFromString(e, current)).toList();
      return;
    }
  }

  @override
  bool shouldRepaint(covariant ShuttleLanes oldDelegate) {
    if(this.data == oldDelegate.data){
      return false;
    }
    return true;
  }

  void drawLabel(Canvas canvas, Size size, String text, BuildContext context) {
    TextSpan sp = TextSpan(style: Theme.of(context).textTheme.bodyText2, text: text);
    TextPainter tp = TextPainter(text: sp, textDirection: TextDirection.ltr);
    tp.layout();
    double dx = 40 - tp.width / 2;
    double dy = size.height / 3 - tp.height / 2;
    Offset offset = Offset(dx, dy);
    tp.paint(canvas, offset);
  }

  void drawText(Canvas canvas, dx, dy, String text, BuildContext context) {
    TextSpan sp = TextSpan(style: Theme.of(context).textTheme.bodyText2, text: text);
    TextPainter tp = TextPainter(text: sp, textDirection: TextDirection.ltr);
    tp.layout();
    dx = dx - tp.width / 2;
    dy = dy - tp.height / 2;
    Offset offset = Offset(dx, dy);
    tp.paint(canvas, offset);
  }

}

class ShuttleStops extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.lightBlue
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4.0;

    final color = Paint()
      ..color = Colors.white
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4.0;

    final rect = Rect.fromLTWH(60, 10, size.width - 80, size.height - 10);
    canvas.drawRRect(RRect.fromRectAndRadius(rect, Radius.circular(40)), paint);
    drawText(canvas, size, "기숙사", 90, size.height * 0.625);
    drawText(canvas, size, "셔틀콕", 155, size.height * 0.625);
    drawText(canvas, size, "한대앞", 220, size.height * 0.625);
    drawText(canvas, size, "예술인", 285, size.height * 0.625);
    drawText(canvas, size, "셔틀콕 건너편", 350, size.height * 0.625);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

  void drawText(Canvas canvas, Size size, String text, dx, dy) {
    TextSpan sp = TextSpan(style: TextStyle(fontSize: 11, fontFamily: "Noto Sans KR", color: Colors.white, fontWeight: FontWeight.bold), text: text);
    TextPainter tp = TextPainter(text: sp, textDirection: TextDirection.ltr);
    tp.layout();
    dx = dx - tp.width / 2;
    dy = dy - tp.height / 2;
    Offset offset = Offset(dx, dy);
    tp.paint(canvas, offset);
  }
}