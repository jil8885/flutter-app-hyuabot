import 'dart:async';

import 'package:chatbot/main.dart';
import 'package:chatbot/config/common.dart';
import 'package:chatbot/model/Shuttle.dart';
import 'package:chatbot/ui/bottomsheets/TransportSheets.dart';
import 'package:chatbot/ui/custompaints/shuttleLines.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class TransportMenuButtons extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        backMenuButton(context),
        Flexible(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _makeFuncButton(context, "셔틀", 0, "assets/images/shared/sheet-header-shuttle.png", _shuttleSheets(context)),
              _makeFuncButton(context, "전철", 1, "assets/images/shared/sheet-header-metro.png"),
              _makeFuncButton(context, "노선버스", 2, "assets/images/shared/sheet-header-bus.png"),
            ],
          ),
        ),
      ],
    );
  }

  Widget _makeFuncButton(BuildContext context, String buttonText, int index, String assetPath, [Widget contents]){
    contents ??= Container();
    return StreamBuilder<int>(
      stream: subButtonController.subButtonIndex,
      builder: (context, snapshot) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: RaisedButton(
            child: Text(buttonText, style: TextStyle(fontSize: 12, fontFamily: "Noto Sans KR", color: snapshot.data == index ? Colors.white : Colors.black),),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            color: snapshot.data == index ? Theme.of(context).accentColor : Colors.white,
            elevation: 6,
            onPressed: (){
              subButtonController.updateSubButtonIndex(index);
              showMaterialModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (context, scrollController) => TransportSheets(assetPath, contents));
            },
          ),
        );
      }
    );
  }

  Widget _shuttleSheets(BuildContext context){
    DateTime current = DateTime.now();
    Timer.periodic(Duration(seconds: 30), (timer) {
      allShuttleController.fetch();
    });

    return StreamBuilder<Map<String, ShuttleStopDepartureInfo>>(
      stream: allShuttleController.allShuttleInfo,
      builder: (context, snapshot) {
        if(snapshot.hasError || !snapshot.hasData){
          return CircularProgressIndicator();
        }
        else {
          Map<String, ShuttleStopDepartureInfo> _data = snapshot.data;
          Map<String, Map<String, List<String>>> _result = {"DH":{}, "DY":{}, "C":{}};
          for(String stop in _data.keys){
            _result["DH"][stop] = _data[stop].shuttleListStation.map((e) => e.toString()).toList();
            _result["DY"][stop] = _data[stop].shuttleListTerminal.map((e) => e.toString()).toList();
            _result["C"][stop] = _data[stop].shuttleListCycle.map((e) => e.toString()).toList();
          }
          return Column(
            children: [
              CustomPaint(painter: ShuttleStops(), size: Size(400, 30)),
              CustomPaint(
                painter: ShuttleLanes("한대앞행", context, _result["DH"]), size: Size(360, 95),),
              CustomPaint(
                painter: ShuttleLanes("예술인행", context, _result["DY"]), size: Size(360, 95),),
              CustomPaint(
                painter: ShuttleLanes("순환버스", context, _result["C"]), size: Size(360, 95),)
            ],
          );
        }
      }
    );
  }
}