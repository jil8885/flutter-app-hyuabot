import 'package:flutter/material.dart';
import 'package:flutter_app_hyuabot_v2/Model/Shuttle.dart';

class ShuttlePaint extends CustomPainter{
  final Map<String, ShuttleStopDepartureInfo> data;
  final BuildContext context;
  ShuttlePaint(this.data, this.context);

  void drawStop(Offset pos, Canvas canvas){
    final _greyCircle = Paint()
      ..color = Colors.grey
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 6.0;

    final _greyLine = Paint()
      ..color = Colors.grey
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.0;

    final _whiteCircle = Paint()
      ..color = Colors.white
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 6.0;

    canvas.drawCircle(pos, 8, _greyCircle);
    canvas.drawCircle(pos, 6, _whiteCircle);
    canvas.drawLine(Offset(pos.dx - 2, pos.dy - 1), Offset(pos.dx, pos.dy + 1), _greyLine);
    canvas.drawLine(Offset(pos.dx + 2, pos.dy - 1), Offset(pos.dx, pos.dy + 1), _greyLine);
  }

  void drawText(Canvas canvas, Offset offset, String text, BuildContext context) {
    TextSpan sp = TextSpan(style: Theme.of(context).textTheme.bodyText1, text: text);
    TextPainter tp = TextPainter(text: sp, textDirection: TextDirection.ltr);
    tp.layout();
    Offset location = Offset(offset.dx - 40 - tp.width * .5, offset.dy - tp.height * .5);
    tp.paint(canvas, location);
  }

  @override
  void paint(Canvas canvas, Size size) {
    // Paint for line
    final _line = Paint()
      ..color = Colors.grey
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 6.0;

    // 노선
    canvas.drawLine(Offset(size.width - 50, 60), Offset(size.width - 50, 350), _line);
    canvas.drawLine(Offset(size.width * .7625 - 50, 60), Offset(size.width * .7625 - 50, 350), _line);
    canvas.drawLine(Offset(size.width * .525 - 50, 60), Offset(size.width * .525 - 50, 350), _line);

    // 정류장
    drawStop(Offset(size.width * .525 - 50, 60), canvas);
    drawStop(Offset(size.width * .525 - 50, 60 + 290 * .25), canvas);
    drawStop(Offset(size.width * .525 - 50, 60 + 290 * .5), canvas);
    drawStop(Offset(size.width * .525 - 50, 350), canvas);

    drawStop(Offset(size.width * .7625 - 50, 60), canvas);
    drawStop(Offset(size.width * .7625 - 50, 60 + 290 * .25), canvas);
    drawStop(Offset(size.width * .7625 - 50, 60 + 290 * .75), canvas);
    drawStop(Offset(size.width * .7625 - 50, 350), canvas);

    drawStop(Offset(size.width - 50, 60), canvas);
    drawStop(Offset(size.width - 50, 60 + 290 * .25), canvas);
    drawStop(Offset(size.width - 50, 60 + 290 * .5), canvas);
    drawStop(Offset(size.width - 50, 60 + 290 * .75), canvas);
    drawStop(Offset(size.width - 50, 350), canvas);

    // 버스 오브젝트
    // 시간표 오브젝트 - Stops

    final _stops = ["Residence", "Shuttlecock_O", "Subway", "YesulIn", "Shuttlecock_I"];



    for(int i = 0; i < _stops.length; i++){
      if(data[_stops[i]].shuttleListStation.length > 1){
        drawText(canvas, Offset(size.width * .525 - 50, 60 + 290 * .25 * i), data[_stops[i]].shuttleListStation.elementAt(0), context);
      }

      if(data[_stops[i]].shuttleListTerminal.length > 1){
        drawText(canvas, Offset(size.width * .7625 - 50, 60 + 290 * .25 * i), data[_stops[i]].shuttleListTerminal.elementAt(0), context);
      }

      if(data[_stops[i]].shuttleListCycle.length > 1){
        drawText(canvas, Offset(size.width - 50, 60 + 290 * .25 * i), data[_stops[i]].shuttleListCycle.elementAt(0), context);
      }
    }

    if(data["Shuttlecock_O"].shuttleListStation.isEmpty){
      drawText(canvas, Offset(size.width * .525 - 55, 415), "운행 종료", context);
    } else {
      for(int i = 0; i < _stops.length; i++) {
        if (data[_stops[i]].shuttleListStation.isEmpty && _stops[i] != "YesulIn") {
          drawText(canvas, Offset(size.width * .525 - 50, 60 + 290 * .25 * i), "운행 종료", context);
        }
      }
    }

    if(data["Shuttlecock_O"].shuttleListTerminal.isEmpty){
      drawText(canvas, Offset(size.width * .7625 - 55, 350), "운행 종료", context);
    } else {
      for(int i = 0; i < _stops.length; i++) {
        if (data[_stops[i]].shuttleListTerminal.isEmpty && _stops[i] != "Subway") {
          drawText(canvas, Offset(size.width * .7625 - 50, 60 + 290 * .25 * i), "운행 종료", context);
        }
      }
    }

    if(data["Shuttlecock_O"].shuttleListCycle.isEmpty){
      drawText(canvas, Offset(size.width - 55, 350), "운행 종료", context);
    } else {
      for(int i = 0; i < _stops.length; i++) {
        if (data[_stops[i]].shuttleListCycle.isEmpty) {
          drawText(canvas, Offset(size.width - 50, 60 + 290 * .25 * i), "운행 종료", context);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant ShuttlePaint oldDelegate) {
    if(oldDelegate.data != this.data){
      return true;
    } else{
      return false;
    }
  }
}