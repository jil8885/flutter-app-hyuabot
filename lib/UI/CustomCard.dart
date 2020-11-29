import 'package:flutter/material.dart';
import 'package:flutter_app_hyuabot_v2/Config/Common.dart';
import 'package:flutter_app_hyuabot_v2/Model/Shuttle.dart';

class CustomShuttleCard extends StatelessWidget {
  double _width;
  double _height;
  String title;
  List<String> timetable;
  ShuttleStopDepartureInfo data;

  CustomShuttleCard({this.title, this.timetable, this.data});

  @override
  Widget build(BuildContext context) {
    _width= MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;

    String remainedTimeString = "";
    String thisBusString = "";
    String nextBusString = "";

    if(timetable.length >= 2){
      DateTime thisBus = getTimeFromString(timetable.elementAt(0), DateTime.now());
      remainedTimeString = '${thisBus.difference(DateTime.now()).inMinutes}분 후';
      thisBusString = "이번 버스 : ${timetable.elementAt(0)}";
      if(data.shuttleListCycle.contains(timetable.elementAt(0))){
        thisBusString += "(순환)";
      } else if(data.shuttleListStation.contains(timetable.elementAt(0)) || data.shuttleListTerminal.contains(timetable.elementAt(0))){
        thisBusString += "(직행)";
      }
      nextBusString = "다음 버스 : ${timetable.elementAt(1)}";
      if(data.shuttleListCycle.contains(timetable.elementAt(1))){
        nextBusString += "(순환)";
      } else if(data.shuttleListStation.contains(timetable.elementAt(1)) || data.shuttleListTerminal.contains(timetable.elementAt(1))){
        nextBusString += "(직행)";
      }
    } else if(timetable.length == 1){
      DateTime thisBus = getTimeFromString(timetable.elementAt(0), DateTime.now());
      remainedTimeString = '${thisBus.difference(DateTime.now()).inMinutes}분 후';
      thisBusString = "이번 버스 : ${timetable.elementAt(0)}";
      if(data.shuttleListCycle.contains(timetable.elementAt(0))){
        thisBusString += "(순환)";
      } else if(data.shuttleListStation.contains(timetable.elementAt(0)) || data.shuttleListTerminal.contains(timetable.elementAt(0))){
        thisBusString += "(직행)";
      }
      nextBusString = "막차입니다.";
    } else {
      thisBusString = "운영 종료";
    }

    return Card(
      elevation: 3,
      shape:
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      color: Colors.white,
      child: Container(
        padding: EdgeInsets.only(left: 10, top: 10, right: 5, bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: _height/40),
                ),
                SizedBox(
                  height: 10,
                ),
                Flexible(
                  child: Container(width: _width / 2.5,
                      child: Text(remainedTimeString, style: TextStyle(fontSize: _height/30,), maxLines: 1, overflow: TextOverflow.ellipsis, softWrap: true,)),
                ),
                SizedBox(height: 20,),
                Container(width: _width / 2.25,
                    child: Text(thisBusString, style: TextStyle(fontSize: _height/40,), maxLines: 1, overflow: TextOverflow.ellipsis, softWrap: true,)
                ),
                SizedBox(height: 5),
                Container(width: _width / 2.25,
                    child: Text(nextBusString, style: TextStyle(fontSize: _height/40,), maxLines: 1, overflow: TextOverflow.ellipsis, softWrap: true,)),
              ],
            ),
            SizedBox(
              width: 10,
            ),
          ],
        ),
      ),
    );
  }
}