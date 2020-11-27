import 'package:chatbot/config/Common.dart';
import 'package:chatbot/config/Localization.dart';
import 'package:chatbot/main.dart';
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

    final line = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4.0;

    final color = Paint()
      ..color = Color.fromRGBO(153, 255, 0, 1)
      ..style = PaintingStyle.fill;

    final radius = 4.5;

    double max = size.width;
    double startHalt = 0;
    double endHalt = 0;
    // 도형 그리기
    canvas.drawLine(Offset(90, size.height / 2), Offset(max - 60, size.height / 2), line);
    drawLabel(canvas, size, label, context);

    String result;
    List<DateTime> timeTable;

    String localeCode = prefs.getString("localeCode");
    timeTable = data["Residence"].map((e) => getTimeFromString(e, current)).toList();
    if(timeTable.length > 0){
      Duration diff = timeTable[0].difference(current);
      result = DateFormat('HH:mm').format(timeTable[0]);
      drawText(canvas, 90, size.height * .25, result.trim(), context);
      switch(localeCode){
        case "ko_KR":
          result = "${diff.inMinutes}분 후\n";
          break;
        case "en_US":
          result = "${diff.inMinutes}mins\n";
          break;
        case "zh":
          result = "${diff.inMinutes}分 後\n";
          break;
      }
      drawText(canvas, 90, size.height * .75, result.trim(), context);
    } else{
      startHalt = 90;
      endHalt = 90;
    }

    timeTable = data["Shuttlecock_O"].map((e) => getTimeFromString(e, current)).toList();
    if(timeTable.length > 0){
      Duration diff = timeTable[0].difference(current);
      result = DateFormat('HH:mm').format(timeTable[0]);
      drawText(canvas, 90 + (max - 150) * .25, size.height * .25, result.trim(), context);
      switch(localeCode){
        case "ko_KR":
          result = "${diff.inMinutes}분 후\n";
          break;
        case "en_US":
          result = "${diff.inMinutes}mins\n";
          break;
        case "zh":
          result = "${diff.inMinutes}分 後\n";
          break;
      }      drawText(canvas, 90 + (max - 150) * .25, size.height * .75, result.trim(), context);
    } else{
      endHalt = 90 + (max - 150) * .25;
    }

    timeTable = data["Subway"].map((e) => getTimeFromString(e, current)).toList();
    if(timeTable.length > 0){
      Duration diff = timeTable[0].difference(current);
      result = DateFormat('HH:mm').format(timeTable[0]);
      drawText(canvas, 90 + (max - 150) * .5, size.height * .25, result.trim(), context);
      switch(localeCode){
        case "ko_KR":
          result = "${diff.inMinutes}분 후\n";
          break;
        case "en_US":
          result = "${diff.inMinutes}mins\n";
          break;
        case "zh":
          result = "${diff.inMinutes}分 後\n";
          break;
      }      drawText(canvas, 90 + (max - 150) * .5, size.height * .75, result.trim(), context);
    } else if(!label.contains("예술인")){
      endHalt = 90 + (max - 150) * .5;
    }

    timeTable = data["YesulIn"].map((e) => getTimeFromString(e, current)).toList();
    if(timeTable.length > 0){
      Duration diff = timeTable[0].difference(current);
      result = DateFormat('HH:mm').format(timeTable[0]);
      drawText(canvas, 90 + (max - 150) * .75, size.height * .25, result.trim(), context);
      switch(localeCode){
        case "ko_KR":
          result = "${diff.inMinutes}분 후\n";
          break;
        case "en_US":
          result = "${diff.inMinutes}mins\n";
          break;
        case "zh":
          result = "${diff.inMinutes}分 後\n";
          break;
      }      drawText(canvas, 90 + (max - 150) * .75, size.height * .75, result.trim(), context);
    } else if(!label.contains("한대앞")){
      endHalt = 90 + (max - 150) * .75;
    }

    timeTable = data["Shuttlecock_I"].map((e) => getTimeFromString(e, current)).toList();
    if(timeTable.length > 0){
      Duration diff = timeTable[0].difference(current);
      result = DateFormat('HH:mm').format(timeTable[0]);
      drawText(canvas, 90 + (max - 150), size.height * .25, result.trim(), context);
      switch(localeCode){
        case "ko_KR":
          result = "${diff.inMinutes}분 후\n";
          break;
        case "en_US":
          result = "${diff.inMinutes}mins\n";
          break;
        case "zh":
          result = "${diff.inMinutes}分 後\n";
          break;
      }      drawText(canvas, 90 + (max - 150), size.height * .75, result.trim(), context);
    } else{
      endHalt = 90 + (max - 150);
    }

    switch(localeCode){
      case "ko_KR":
        result = "운행 종료\n";
        break;
      case "en_US":
        result = "Out of service\n";
        break;
      case "zh":
        result = "運行 終了\n";
        break;
    }

    if(startHalt != 0){
      drawText(canvas, (startHalt + endHalt) / 2, size.height * .75, result, context);
    }
    var touchableCanvas = TouchyCanvas(context, canvas);
    touchableCanvas.drawCircle(Offset(90, size.height / 2), radius, paint, onTapDown: (tapDetail){
      print("Residence");
    });
    touchableCanvas.drawCircle(Offset(90 + (max - 150) * .25, size.height / 2), radius, paint, onTapDown: (tapDetail){
      print("Shuttlecock_O");
    });
    if (!label.contains(Translations.of(context).trans('bound_terminal'))) {
      touchableCanvas.drawCircle(Offset(90  + (max - 150) * .5, size.height / 2), radius, paint, onTapDown: (tapDetail){
        print("Station");
      });
    }
    if (!label.contains(Translations.of(context).trans('bound_station'))) {
      touchableCanvas.drawCircle(Offset(90 + (max - 150) * .75, size.height / 2), radius, paint, onTapDown: (tapDetail){
        print("Terminal");
      });
    }
    touchableCanvas.drawCircle(Offset(90 + (max - 150), size.height / 2), radius, paint, onTapDown: (tapDetail){
      print("Shuttlecock_I");
    });

    timeTable = data["Shuttlecock_O"].map((e) => getTimeFromString(e, current)).toList();
    if(timeTable.length > 0){
      Duration diff = timeTable[0].difference(current);
      if(diff.inMinutes <= 5){
        drawBus(touchableCanvas, 90 + (max - 150) * .25 - (max - 150) * .05 * diff.inMinutes, size.height / 2, radius * 1.5, color);
      }
    } else{
      endHalt = 90 + (max - 150) * .25;
    }

    timeTable = data["Subway"].map((e) => getTimeFromString(e, current)).toList();
    if(timeTable.length > 0){
      Duration diff = timeTable[0].difference(current);
      if(diff.inMinutes <= 10){
        drawBus(touchableCanvas, 90 + (max - 150) * .5 - (max - 150) * .025 * diff.inMinutes, size.height / 2, radius * 1.5, color);
      }
    } else if(!label.contains("예술인")){
      endHalt = 90 + (max - 150) * .5;
    }

    timeTable = data["YesulIn"].map((e) => getTimeFromString(e, current)).toList();
    if(timeTable.length > 0){
      Duration diff = timeTable[0].difference(current);
      result = DateFormat('HH:mm').format(timeTable[0]);
      drawText(canvas, 90 + (max - 150) * .75, size.height * .25, result.trim(), context);
      switch(localeCode){
        case "ko_KR":
          result = "${diff.inMinutes}분 후\n";
          break;
        case "en_US":
          result = "${diff.inMinutes}mins\n";
          break;
        case "zh":
          result = "${diff.inMinutes}分 後\n";
          break;
      }      drawText(canvas, 90 + (max - 150) * .75, size.height * .75, result.trim(), context);
      if(label == Translations.of(context).trans('bound_cycle')){
        if(diff.inMinutes <= 5){
          drawBus(touchableCanvas, 90 + (max - 150) * .75 - (max - 150) * .05 * diff.inMinutes, size.height / 2,  radius * 1.5, color);
        }
      } else {
        if(diff.inMinutes <= 10){
          drawBus(touchableCanvas, 90 + (max - 150) * .75 - (max - 150) * .025 * diff.inMinutes, size.height / 2,  radius * 1.5, color);
        }
      }
    } else if(!label.contains(Translations.of(context).trans('bound_station'))){
      endHalt = 90 + (max - 150) * .75;
    }

    timeTable = data["Shuttlecock_I"].map((e) => getTimeFromString(e, current)).toList();
    if(timeTable.length > 0){
      Duration diff = timeTable[0].difference(current);
      result = DateFormat('HH:mm').format(timeTable[0]);
      drawText(canvas, 90 + (max - 150), size.height * .25, result.trim(), context);
      switch(localeCode){
        case "ko_KR":
          result = "${diff.inMinutes}분 후\n";
          break;
        case "en_US":
          result = "${diff.inMinutes}mins\n";
          break;
        case "zh":
          result = "${diff.inMinutes}分 後\n";
          break;
      }      drawText(canvas, 90 + (max - 150), size.height * .75, result.trim(), context);
      if(label.contains(Translations.of(context).trans('bound_station'))){
        if(diff.inMinutes <= 10){
          drawBus(touchableCanvas, 90 + (max - 150) - (max - 150) * .05 * diff.inMinutes, size.height / 2,  radius * 1.5, color);
        }
      } else {
        if(diff.inMinutes <= 10){
          drawBus(touchableCanvas, 90 + (max - 150) - (max - 150) * .025 * diff.inMinutes, size.height / 2,  radius * 1.5, color);
        }
      }
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
    TextSpan sp = TextSpan(style: TextStyle(fontSize: 12, fontFamily: "Noto Sans KR", color: Colors.white, fontWeight: FontWeight.bold), text: text);
    TextPainter tp = TextPainter(text: sp, textDirection: ui.TextDirection.ltr);
    tp.layout();
    double dx = 45 - tp.width / 2;
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

  void drawBus(TouchyCanvas canvas, double dx, double dy, double radius,Paint paint){
    canvas.drawCircle(Offset(dx, dy), radius, paint);
  }
}

class ShuttleStops extends CustomPainter{
  BuildContext context;
  ShuttleStops(this.context);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.lightBlue
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4.0;

    final rect = Rect.fromLTWH(65, 10, size.width - 100, size.height - 10);
    canvas.drawRRect(RRect.fromRectAndRadius(rect, Radius.circular(40)), paint);
    drawText(canvas, size, Translations.of(context).trans("bus_stop_dorm"), 90, size.height * 0.625);
    drawText(canvas, size, Translations.of(context).trans("bus_stop_school"), 90 + (size.width - 150) * .25, size.height * 0.625);
    drawText(canvas, size, Translations.of(context).trans("bus_stop_station"), 90 + (size.width - 150) * .5, size.height * 0.625);
    drawText(canvas, size, Translations.of(context).trans("bus_stop_terminal"), 90 + (size.width - 150) * .75, size.height * 0.625);
    drawText(canvas, size, Translations.of(context).trans("bus_stop_school"), 90 + (size.width - 150), size.height * 0.625);
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