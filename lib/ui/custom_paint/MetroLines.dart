import 'package:chatbot/config/Common.dart';
import 'package:chatbot/model/Metro.dart';
import 'package:flutter/material.dart';

class MetroLanesRealtime extends CustomPainter {
  final isRight;
  final Color lineColor;
  final List stationList;
  final List<MetroRealtimeInfo> data;

  MetroLanesRealtime(this.isRight, this.lineColor, this.stationList, this.data);
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
      ..color = lineColor.withOpacity(0.5)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4.0;

    final metroStation = Paint()
      ..color = lineColor
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4.0;

    // 주 사각형
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(20, 10, size.width - 40, size.height - 20), Radius.circular(10)), white);
    canvas.drawRRect(RRect.fromRectAndCorners(Rect.fromLTWH(20, 10 + (size.height - 20)*.6, size.width - 40, (size.height - 20)*.4), bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)), subBox);
  
    // 화살표(왼쪽/오른쪽)
    canvas.drawLine(Offset(40, size.height / 3), Offset(size.width - 40, size.height / 3), metroLine);
    if(isRight){
      canvas.drawLine(Offset(size.width - 40, size.height / 3), Offset(size.width - 52.5, size.height / 3 - 12.5), metroLine);
    } else{
      canvas.drawLine(Offset(40, size.height / 3), Offset(52.5, size.height / 3 - 12.5), metroLine);
    }
    
    // 각 역 표시
    for(int i=0; i<stationList.length; i++){
      canvas.drawCircle(Offset(70 + (size.width - 140) * (i / (stationList.length - 1)), size.height / 3), 4.0, metroStation);
      TextSpan sp = TextSpan(style: TextStyle(fontSize: 11, fontFamily: "Noto Sans KR", color: Colors.black), text: stationList[i]);
      TextPainter tp = TextPainter(text: sp, textDirection: TextDirection.ltr);
      tp.layout();
      double dx = 70 + (size.width - 140) * (i / (stationList.length - 1)) - tp.width / 2;
      double dy = size.height / 2.25 - tp.height / 2;
      Offset offset = Offset(dx, dy);
      tp.paint(canvas, offset);
    }
    Color textColor;
    for(int i=0; i<data.length; i++){
      if (i == 2) {
        break;
      }
      String result = '(${data[i].terminalStation}행) ${data[i].remainedTime.toInt()}분 후 도착';
      if (data[i].currentStatus != "운행중"){
        result += "-${data[i].currentStatus}";
      } else {
        result += "-${data[i].currentStation}";
      }
      if(i==0){
        textColor = Colors.white;
      } else {
        textColor = Colors.white.withOpacity(0.6);
      }
      TextSpan sp = TextSpan(style: TextStyle(fontSize: 15, fontFamily: "Noto Sans KR", color: textColor, fontWeight: FontWeight.bold), text: result);
      TextPainter tp = TextPainter(text: sp, textDirection: TextDirection.ltr);
      tp.layout();
      double dx = size.width / 2 - tp.width / 2;
      double dy = size.height / 2 - tp.height / 2 + (i + 1.2) * 30;
      Offset offset = Offset(dx, dy);
      tp.paint(canvas, offset);
      if(stationList.contains("한대앞")){
        int time = data[i].remainedTime.toInt();
        if(isRight){
          if(time<=0){
            drawTrain(canvas, size.width - 70, size.height / 3, subBox);
          }else if(time<=2){
            drawTrain(canvas, size.width - 70 - (size.width - 140) * 0.5 / (stationList.length - 1), size.height / 3, subBox);
          }else if(time<=4){
            drawTrain(canvas, size.width - 70 - (size.width - 140) * 1.5 / (stationList.length - 1), size.height / 3, subBox);
          }else if(time<=6.5){
            drawTrain(canvas, size.width - 70 - (size.width - 140) * 2.5 / (stationList.length - 1), size.height / 3, subBox);
          }else if(time<=9){
            drawTrain(canvas, size.width - 70 - (size.width - 140) * 3.5 / (stationList.length - 1), size.height / 3, subBox);
          }
        } else {
          if(time<=0){
            drawTrain(canvas, 70, size.height / 3, subBox);
          }else if(time<=2){
            drawTrain(canvas, 70 + (size.width - 140) * 0.5 / (stationList.length - 1), size.height / 3, subBox);
          }else if(time<=6){
            drawTrain(canvas, 70 + (size.width - 140) * 1.5 / (stationList.length - 1), size.height / 3, subBox);
          }else if(time<=8.5){
            drawTrain(canvas, 70 + (size.width - 140) * 2.5 / (stationList.length - 1), size.height / 3, subBox);
          }else if(time<=11.5){
            drawTrain(canvas, 70 + (size.width - 140) * 3.5 / (stationList.length - 1), size.height / 3, subBox);
          }
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  void drawTrain(Canvas canvas, double dx, double dy, Paint paint){
    canvas.drawCircle(Offset(dx, dy), 6.0 , paint);
  }
}


class MetroLanesTimeTable extends CustomPainter {
  final isRight;
  final Color lineColor;
  final List stationList;
  final List<MetroTimeTableInfo> data;

  MetroLanesTimeTable(this.isRight, this.lineColor, this.stationList, this.data);
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
      ..color = lineColor.withOpacity(0.6)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4.0;

    final metroStation = Paint()
      ..color = lineColor
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4.0;
    // 주 사각형
    canvas.drawRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(20, 10, size.width - 40, size.height - 20),
        Radius.circular(10)), white);
    canvas.drawRRect(RRect.fromRectAndCorners(Rect.fromLTWH(20, 10 + (size.height - 20)*.6, size.width - 40, (size.height - 20)*.4), bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)), subBox);


    // 화살표(왼쪽/오른쪽)
    canvas.drawLine(
        Offset(40, size.height / 3), Offset(size.width - 40, size.height / 3),
        metroLine);
    // 화살표(왼쪽/오른쪽)
    canvas.drawLine(Offset(40, size.height / 3), Offset(size.width - 40, size.height / 3), metroLine);
    if(isRight){
      canvas.drawLine(Offset(size.width - 40, size.height / 3), Offset(size.width - 52.5, size.height / 3 - 12.5), metroLine);
    } else{
      canvas.drawLine(Offset(40, size.height / 3), Offset(52.5, size.height / 3 - 12.5), metroLine);
    }

    // 각 역 표시
    for (int i = 0; i < stationList.length; i++) {
      canvas.drawCircle(Offset(
          70 + (size.width - 140) * (i / (stationList.length - 1)),
          size.height / 3), 4.0, metroLine);
      TextSpan sp = TextSpan(style: TextStyle(
          fontSize: 11, fontFamily: "Noto Sans KR", color: Colors.black),
          text: stationList[i]);
      TextPainter tp = TextPainter(text: sp, textDirection: TextDirection.ltr);
      tp.layout();
      double dx = 70 + (size.width - 140) * (i / (stationList.length - 1)) -
          tp.width / 2;
      double dy = size.height / 2.25 - tp.height / 2;
      Offset offset = Offset(dx, dy);
      tp.paint(canvas, offset);
    }

    for (int i = 0; i < data.length; i++) {
      if (i == 2) {
        break;
      }
      Duration diff = getTimeFromString(data[i].arrivalTime, DateTime.now()).difference(DateTime.now());
      int time = diff.inMinutes;

      String currentStation="";
      if (isRight) {
        if (time <= 0) {
          drawTrain(canvas, size.width - 70, size.height / 3, subBox);
          currentStation = "한대앞";
        } else if (time <= 2) {
          drawTrain(canvas, size.width - 70 -
              (size.width - 140) * 0.5 / (stationList.length - 1),
              size.height / 3, subBox);
          currentStation = "중앙";
        } else if (time <= 4) {
          drawTrain(canvas, size.width - 70 -
              (size.width - 140) * 1.5 / (stationList.length - 1),
              size.height / 3, subBox);
          currentStation = "고잔";
        } else if (time <= 6.5) {
          drawTrain(canvas, size.width - 70 -
              (size.width - 140) * 2.5 / (stationList.length - 1),
              size.height / 3, subBox);
          currentStation = "초지";
        } else if (time <= 9) {
          drawTrain(canvas, size.width - 70 -
              (size.width - 140) * 3.5 / (stationList.length - 1),
              size.height / 3, subBox);
          currentStation = "안산";
        }
        else if (time <= 12.5) {
          currentStation = "신길온천";
        }
        else if (time <= 16) {
          currentStation = "정왕";
        }
        else if (time <= 19) {
          currentStation = "오이도";
        }
        else if (time <= 21) {
          currentStation = "달월";
        }
        else if (time <= 23) {
          currentStation = "월곶";
        }
        else if (time <= 25) {
          currentStation = "소래포구";
        }
        else if (time <= 27) {
          currentStation = "인천논현";
        }
        else if (time <= 29) {
          currentStation = "호구포";
        }
      } else {
        if (time <= 0) {
          drawTrain(canvas, 70, size.height / 3, subBox);
          currentStation = "한대앞";
        } else if (time <= 2) {
          drawTrain(canvas,
              70 + (size.width - 140) * 0.5 / (stationList.length - 1),
              size.height / 3, subBox);
          currentStation = "사리";
        } else if (time <= 7) {
          drawTrain(canvas,
              70 + (size.width - 140) * 1.5 / (stationList.length - 1),
              size.height / 3, subBox);
          currentStation = "야목";
        } else if (time <= 10) {
          drawTrain(canvas,
              70 + (size.width - 140) * 2.5 / (stationList.length - 1),
              size.height / 3, subBox);
          currentStation = "어천";
        } else if (time <= 14) {
          drawTrain(canvas,
              70 + (size.width - 140) * 3.5 / (stationList.length - 1),
              size.height / 3, subBox);
          currentStation = "오목천";
        }
        else if (time <= 17) {
          currentStation = "고색";
        }
        else if (time <= 21) {
          currentStation = "수원";
        }
        else if (time <= 25) {
          currentStation = "매교";
        }
        else if (time <= 26) {
          currentStation = "수원시청";
        }
        else if (time <= 29) {
          currentStation = "매탄권선";
        }
      }
      Color textColor;
      if(i==0){
        textColor = Colors.white;
      } else {
        textColor = Colors.white.withOpacity(0.6);
      }
      String result = '(${data[i].terminalStation}행) ${data[i].arrivalTime} 도착';
      if(currentStation != ""){
        result += " - 예상 위치:$currentStation";
      }
      TextSpan sp = TextSpan(style: TextStyle(fontSize: 15,
          fontFamily: "Noto Sans KR",
          color: textColor,
          fontWeight: FontWeight.bold), text: result);
      TextPainter tp = TextPainter(text: sp, textDirection: TextDirection.ltr);
      tp.layout();
      double dx = size.width / 2 - tp.width / 2;
      double dy = size.height / 2 - tp.height / 2 + (i + 1.2) * 30;
      Offset offset = Offset(dx, dy);
      tp.paint(canvas, offset);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  void drawTrain(Canvas canvas, double dx, double dy, Paint paint){
    canvas.drawCircle(Offset(dx, dy), 6.0 , paint);
  }

}