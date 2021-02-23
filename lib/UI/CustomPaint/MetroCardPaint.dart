import 'package:flutter/material.dart';
import 'package:flutter_app_hyuabot_v2/Config/Common.dart';
import 'package:flutter_app_hyuabot_v2/Config/GlobalVars.dart';
import 'package:flutter_app_hyuabot_v2/Model/Metro.dart';

class MetroRealtimeCardPaint extends CustomPainter{
  final BuildContext context;
  final List<MetroRealtimeInfo> data;
  final Color lineColor;
  MetroRealtimeCardPaint(this.context, this.data, this.lineColor);

  void drawRemainedTime(Canvas canvas, Offset offset, String text) {
    TextSpan sp = TextSpan(style: TextStyle(color: Theme.of(context).backgroundColor == Colors.white ? Colors.black : Colors.white, fontSize: 12, fontFamily: "Godo"), text: text);
    TextPainter tp = TextPainter(text: sp, textDirection: TextDirection.ltr);
    tp.layout();
    Offset location = Offset(offset.dx, offset.dy - tp.height * .5);
    tp.paint(canvas, location);
  }

  String _resultString(MetroRealtimeInfo info, String status){
    String _result;
    Map<String, String> langDict;
    switch(prefManager.getString("localeCode")){
      case "ko_KR":
        _result = '${info.terminalStation}행 ${info.remainedTime.toInt()}분 ($status)';
        break;
      case "en_US":
        langDict = {"당고개": "Danggogae", "노원": "Nowon", "한성대입구": "Hansung Univ.", "사당": "Sadang", "금정": "Gumjeong", "오이도": "Oido", "안산": "Ansan"};
        _result = '${info.remainedTime.toInt()} minutes left (Bound for ${langDict[info.terminalStation]})';
        break;
      case 'zh':
        langDict = {"당고개": "Danggogae", "노원": "Nowon", "한성대입구": "Hansung Univ.", "사당": "Sadang", "금정": "Gumjeong", "오이도": "Oido", "안산": "Ansan"};
        _result = '${info.remainedTime.toInt()} minutes left (Bound for ${langDict[info.terminalStation]})';
        break;
    }

    return _result;
  }

  @override
  void paint(Canvas canvas, Size size) {
    // Paint for line
    final _line = Paint()
      ..color = Colors.grey
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.0;

    // Paint for White circle
    final _white = Paint()
      ..color = Colors.white
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.0;

    // Paint for line Circle
    final _colorPaint = Paint()
      ..color = lineColor
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.0;

    double _dashWidth = 3;
    double _dashSpace = 2;
    double _start = 10;
    final space = (_dashSpace + _dashWidth);

    while (_start < 35) {
      canvas.drawLine(Offset(10, _start), Offset(10, _start + _dashSpace), _line);
      _start += space;
    }

    canvas.drawCircle(Offset(10, 10), 5.0, _colorPaint);
    canvas.drawCircle(Offset(10, 35), 5.0, _line);
    canvas.drawCircle(Offset(10, 35), 3.0, _white);

    String status;
    if(data.length >= 2){
      if(data.elementAt(0).currentStatus.toString().contains("전역")){
        status = data.elementAt(0).currentStatus;
      } else if(data.elementAt(0).currentStatus.toString() == "운행중"){
        status = data.elementAt(0).currentStation;
      } else {
        status = '${data.elementAt(0).currentStation} ${data.elementAt(0).currentStatus}';
      }

      drawRemainedTime(canvas, Offset(25, 10), _resultString(data.elementAt(0), status));

      if(data.elementAt(1).currentStatus.toString().contains("전역")){
        status = data.elementAt(1).currentStatus;
      } else if(data.elementAt(1).currentStatus.toString() == "운행중"){
        status = data.elementAt(1).currentStation;
      } else {
        status = '${data.elementAt(1).currentStation} ${data.elementAt(1).currentStatus}';
      }

      drawRemainedTime(canvas, Offset(25, 35), _resultString(data.elementAt(1), status));
    } else if(data.length == 1){
      if(data.elementAt(0).currentStatus.toString().contains("전역")){
        status = data.elementAt(0).currentStatus;
      } else if(data.elementAt(0).currentStatus.toString() == "운행중"){
        status = data.elementAt(0).currentStation;
      } else {
        status = '${data.elementAt(0).currentStation} ${data.elementAt(0).currentStatus}';
      }
      drawRemainedTime(canvas, Offset(25, 10), _resultString(data.elementAt(0), status));
      drawRemainedTime(canvas, Offset(25, 35), '정보 없음');
    } else {
      drawRemainedTime(canvas, Offset(25, 10), '운행 종료 또는 API 운영사의 오류입니다.');
    }
  }

  @override
  bool shouldRepaint(covariant MetroRealtimeCardPaint oldDelegate) {
    if(oldDelegate.data != this.data){
      return true;
    } else{
      return false;
    }
  }
}

class MetroTimeTableCardPaint extends CustomPainter{
  final BuildContext context;
  final List<MetroTimeTableInfo> data;
  final Color lineColor;

  MetroTimeTableCardPaint(this.context, this.data, this.lineColor);

  void drawRemainedTime(Canvas canvas, Offset offset, String text) {
    TextSpan sp = TextSpan(style: TextStyle(color: Theme.of(context).backgroundColor == Colors.white ? Colors.black : Colors.white, fontSize: 12, fontFamily: "Godo"), text: text);
    TextPainter tp = TextPainter(text: sp, textDirection: TextDirection.ltr);
    tp.layout();
    Offset location = Offset(offset.dx, offset.dy - tp.height * .5);
    tp.paint(canvas, location);
  }

  String _resultString(MetroTimeTableInfo info){
    String _result;
    Map<String, String> langDict;
    DateTime now = DateTime.now();
    switch(prefManager.getString("localeCode")){
      case "ko_KR":
        _result = '${info.terminalStation}행 ${getTimeFromString(info.arrivalTime.toString(), now).difference(now).inMinutes}분';
        break;
      case "en_US":
        langDict = {"왕십리": "Wangsimni", "청량리": "Cheongryangri", "죽전": "Jukjeon", "고색": "Gosaek", "인천": "Incheon", "오이도": "Oido"};
        _result = '${getTimeFromString(info.arrivalTime.toString(), now).difference(now).inMinutes} minutes left (Bound for ${langDict[info.terminalStation]})';
        break;
      case "zh":
        langDict = {"왕십리": "Wangsimni", "청량리": "Cheongryangri", "죽전": "Jukjeon", "고색": "Gosaek", "인천": "Incheon", "오이도": "Oido"};
        _result = '${getTimeFromString(info.arrivalTime.toString(), now).difference(now).inMinutes} minutes left (Bound for ${langDict[info.terminalStation]})';
        break;
    }

    return _result;
  }

  @override
  void paint(Canvas canvas, Size size) {
    // Paint for line
    final _line = Paint()
      ..color = Colors.grey
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.0;

    // Paint for White circle
    final _white = Paint()
      ..color = Colors.white
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.0;

    // Paint for line Circle
    final _colorPaint = Paint()
      ..color = lineColor
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.0;

    double _dashWidth = 3;
    double _dashSpace = 2;
    double _start = 10;
    final space = (_dashSpace + _dashWidth);

    while (_start < 35) {
      canvas.drawLine(Offset(10, _start), Offset(10, _start + _dashSpace), _line);
      _start += space;
    }

    canvas.drawCircle(Offset(10, 10), 5.0, _colorPaint);
    canvas.drawCircle(Offset(10, 35), 5.0, _line);
    canvas.drawCircle(Offset(10, 35), 3.0, _white);

    if(data.length >= 2){
      drawRemainedTime(canvas, Offset(25, 10), _resultString(data.elementAt(0)));
      drawRemainedTime(canvas, Offset(25, 35), _resultString(data.elementAt(1)));
    } else if(data.length == 1){
      drawRemainedTime(canvas, Offset(25, 10), _resultString(data.elementAt(0)));
    } else {
      drawRemainedTime(canvas, Offset(25, 10), '운행 종료');
    }
  }

  @override
  bool shouldRepaint(covariant MetroTimeTableCardPaint oldDelegate) {
    if(oldDelegate.data != this.data){
      return true;
    } else{
      return false;
    }
  }
}