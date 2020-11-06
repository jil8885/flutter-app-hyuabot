import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:chatbot/main.dart';
import 'package:chatbot/config/common.dart';
import 'package:chatbot/model/Shuttle.dart';
import 'package:chatbot/ui/bottom_sheet/TransportSheets.dart';
import 'package:chatbot/ui/custompaints/shuttleLines.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';


class TransportMenuButtons extends StatefulWidget{
  @override
  State<StatefulWidget> createState()=> TransportMenuStates();
}

class TransportMenuStates extends State<TransportMenuButtons>{
  ui.Image busIcon;
  @override
  void initState() {
    _loadImage();
  }

  _loadImage() async {
    ByteData bd = await rootBundle.load("assets/images/shared/bus-icon.png");

    final Uint8List bytes = Uint8List.view(bd.buffer);

    final ui.Codec codec = await ui.instantiateImageCodec(bytes);

    final ui.Image image = (await codec.getNextFrame()).image;

    setState(() => busIcon = image);
  }

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
              _makeFuncButton(context, "셔틀", 0, "assets/images/shared/sheet-header-shuttle.png", 0.35, _shuttleSheets(context, busIcon)),
              _makeFuncButton(context, "전철", 1, "assets/images/shared/sheet-header-metro.png", 0.55),
              _makeFuncButton(context, "노선버스", 2, "assets/images/shared/sheet-header-bus.png", 0.65),
            ],
          ),
        ),
      ],
    );
  }

  Widget _makeFuncButton(BuildContext context, String buttonText, int index, String assetPath, double height ,[Widget contents]){
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
                  builder: (context, scrollController) => TransportSheets(assetPath, contents, height));
            },
          ),
        );
      }
    );
  }

  Widget _shuttleSheets(BuildContext context, ui.Image icon){
    Timer.periodic(Duration(seconds: 60), (timer) {
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
              CustomPaint(painter: ShuttleStops(), size: Size(MediaQuery.of(context).size.width, 30)),
              CustomPaint(
                painter: ShuttleLanes("한대앞행", context, _result["DH"], icon), size: Size(MediaQuery.of(context).size.width, 75),),
              CustomPaint(
                painter: ShuttleLanes("예술인행", context, _result["DY"], icon), size: Size(MediaQuery.of(context).size.width, 75),),
              CustomPaint(
                painter: ShuttleLanes("순환버스", context, _result["C"], icon), size: Size(MediaQuery.of(context).size.width, 75),),
              // Container(
              //   height: 20,
              //   padding: EdgeInsets.symmetric(horizontal: 35),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.end,
              //     children: [IconButton(icon: Icon(Icons.refresh), onPressed: (){allShuttleController.fetch();})
            ],
          );
        }
      }
    );
  }
}