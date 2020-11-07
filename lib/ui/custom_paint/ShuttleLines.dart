import 'dart:io';

import 'package:chatbot/config/common.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:intl/intl.dart';
import 'package:touchable/touchable.dart';

class ShuttleLanes extends CustomPainter{
  final String label;
  final BuildContext context;
  final Map<String, List<String>> data;
  ShuttleLanes(this.label, this.context, this.data);

  @override
  void paint(Canvas canvas, Size size){
    DateTime current = DateTime.now();
    final paint = Paint()
      ..color = Colors.white
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4.0;

    final color = Paint()
      ..color = Color.fromRGBO(153, 255, 0, 1)
      ..style = PaintingStyle.fill;

    final radius = 4.5;

    double max = size.width;
    // 도형 그리기
    canvas.drawLine(Offset(70, size.height / 2), Offset(max - 40, size.height / 2), paint);
    drawLabel(canvas, size, label, context);

    String result;
    List<DateTime> timeTable;

    timeTable = data["Residence"].map((e) => getTimeFromString(e, current)).toList();
    if(timeTable.length > 0){
      Duration diff = timeTable[0].difference(current);
      result = DateFormat('HH:mm').format(timeTable[0]);
      drawText(canvas, 70, size.height * .25, result.trim(), context);
      result = "${diff.inMinutes}분 후\n";
      drawText(canvas, 70, size.height * .75, result.trim(), context);
    }

    timeTable = data["Shuttlecock_O"].map((e) => getTimeFromString(e, current)).toList();
    if(timeTable.length > 0){
      Duration diff = timeTable[0].difference(current);
      result = DateFormat('HH:mm').format(timeTable[0]);
      drawText(canvas, 70 + (max - 110) * .25, size.height * .25, result.trim(), context);
      result = "${diff.inMinutes}분 후\n";
      drawText(canvas, 70 + (max - 110) * .25, size.height * .75, result.trim(), context);
      if(diff.inMinutes <= 5){
        drawArrow(canvas, 70 + (max - 110) * .25 - (max - 110) * .05 * diff.inMinutes, size.height / 2, color);
      }
    }

    timeTable = data["Subway"].map((e) => getTimeFromString(e, current)).toList();
    if(timeTable.length > 0){
      Duration diff = timeTable[0].difference(current);
      result = DateFormat('HH:mm').format(timeTable[0]);
      drawText(canvas, 70 + (max - 110) * .5, size.height * .25, result.trim(), context);
      result = "${diff.inMinutes}분 후\n";
      drawText(canvas, 70 + (max - 110) * .5, size.height * .75, result.trim(), context);
      if(diff.inMinutes <= 10){
        drawArrow(canvas, 70 + (max - 110) * .5 - (max - 110) * .025 * diff.inMinutes, size.height / 2, color);
      }
    }

    timeTable = data["YesulIn"].map((e) => getTimeFromString(e, current)).toList();
    if(timeTable.length > 0){
      Duration diff = timeTable[0].difference(current);
      result = DateFormat('HH:mm').format(timeTable[0]);
      drawText(canvas, 70 + (max - 110) * .75, size.height * .25, result.trim(), context);
      result = "${diff.inMinutes}분 후\n";
      drawText(canvas, 70 + (max - 110) * .75, size.height * .75, result.trim(), context);
      if(label.contains("순환버스")){
        if(diff.inMinutes <= 5){
          drawArrow(canvas, 70 + (max - 110) * .75 - (max - 110) * .05 * diff.inMinutes, size.height / 2, color);
        }
      } else {
        if(diff.inMinutes <= 10){
          drawArrow(canvas, 70 + (max - 110) * .75 - (max - 110) * .025 * diff.inMinutes, size.height / 2, color);
        }
      }
    }

    timeTable = data["Shuttlecock_I"].map((e) => getTimeFromString(e, current)).toList();
    if(timeTable.length > 0){
      Duration diff = timeTable[0].difference(current);
      result = DateFormat('HH:mm').format(timeTable[0]);
      drawText(canvas, 70 + (max - 110), size.height * .25, result.trim(), context);
      result = "${diff.inMinutes}분 후\n";
      drawText(canvas, 70 + (max - 110), size.height * .75, result.trim(), context);
      if(label.contains("한대앞")){
        if(diff.inMinutes <= 10){
          drawArrow(canvas, 70 + (max - 110) - (max - 110) * .05 * diff.inMinutes, size.height / 2, color);
        }
      } else {
        if(diff.inMinutes <= 10){
          drawArrow(canvas, 70 + (max - 110) - (max - 110) * .025 * diff.inMinutes, size.height / 2, color);
        }
      }
    }

    var touchableCanvas = TouchyCanvas(context, canvas);
    touchableCanvas.drawCircle(Offset(70, size.height / 2), radius, paint, onTapDown: (tapDetail){
      print("Residence");
    });
    touchableCanvas.drawCircle(Offset(70 + (max - 110) * .25, size.height / 2), radius, paint, onTapDown: (tapDetail){
      print("Shuttlecock_O");
    });
    if (!this.label.contains("예술인")) {
      touchableCanvas.drawCircle(Offset(70  + (max - 110) * .5, size.height / 2), radius, paint, onTapDown: (tapDetail){
        print("Station");
      });
    }
    if (!this.label.contains("한대앞")) {
      touchableCanvas.drawCircle(Offset(70 + (max - 110) * .75, size.height / 2), radius, paint, onTapDown: (tapDetail){
        print("Terminal");
      });
    }
    touchableCanvas.drawCircle(Offset(70 + (max - 110), size.height / 2), radius, paint, onTapDown: (tapDetail){
      print("Shuttlecock_I");
    });

    if(label.contains("한대앞")){
      timeTable = data["Subway"].map((e) => getTimeFromString(e, current)).toList();
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
    TextSpan sp = TextSpan(style: TextStyle(fontSize: 11, fontFamily: "Noto Sans KR", color: Colors.white), text: text);
    TextPainter tp = TextPainter(text: sp, textDirection: ui.TextDirection.ltr);
    tp.layout();
    double dx = 30 - tp.width / 2;
    double dy = size.height / 2 - tp.height / 2;
    Offset offset = Offset(dx, dy);
    tp.paint(canvas, offset);
  }

  void drawText(Canvas canvas, dx, dy, String text, BuildContext context) {
    TextSpan sp = TextSpan(style: TextStyle(fontSize: 11, fontFamily: "Noto Sans KR", color: Colors.white), text: text);
    TextPainter tp = TextPainter(text: sp, textDirection: ui.TextDirection.ltr);
    tp.layout();
    dx = dx - tp.width / 2;
    dy = dy - tp.height / 2;
    Offset offset = Offset(dx, dy);
    tp.paint(canvas, offset);
  }

  void drawArrow(Canvas canvas, double dx, double dy, Paint paint){
    final path = Path()
        ..moveTo(dx + 7.5, dy)
        ..lineTo(dx - 7.5, dy - 7.5)
        ..quadraticBezierTo(dx, dy, dx - 7.5, dy + 7.5)
        ..close();
    canvas.drawPath(path, paint);
  }
}

class ShuttleStops extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.lightBlue
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4.0;

    final rect = Rect.fromLTWH(20, 10, size.width - 30, size.height - 10);
    canvas.drawRRect(RRect.fromRectAndRadius(rect, Radius.circular(40)), paint);
    drawText(canvas, size, "기숙사", 70, size.height * 0.625);
    drawText(canvas, size, "셔틀콕", 70 + (size.width - 110) * .25, size.height * 0.625);
    drawText(canvas, size, "한대앞", 70 + (size.width - 110) * .5, size.height * 0.625);
    drawText(canvas, size, "예술인", 70 + (size.width - 110) * .75, size.height * 0.625);
    drawText(canvas, size, "셔틀콕 건너편", 70 + (size.width - 110) * .975, size.height * 0.625);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

  void drawText(Canvas canvas, Size size, String text, dx, dy) {
    TextSpan sp = TextSpan(style: TextStyle(fontSize: 11, fontFamily: "Noto Sans KR", color: Colors.white, fontWeight: FontWeight.bold), text: text);
    TextPainter tp = TextPainter(text: sp, textDirection: ui.TextDirection.ltr);
    tp.layout();
    dx = dx - tp.width / 2;
    dy = dy - tp.height / 2;
    Offset offset = Offset(dx, dy);
    tp.paint(canvas, offset);
  }
}