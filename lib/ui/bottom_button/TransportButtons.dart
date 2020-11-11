import 'dart:async';


import 'package:chatbot/config/style.dart';
import 'package:chatbot/main.dart';
import 'package:chatbot/config/common.dart';
import 'package:chatbot/model/Shuttle.dart';
import 'package:chatbot/ui/bottom_sheet/TransportSheets.dart';
import 'package:chatbot/ui/custom_paint/ShuttleLines.dart';
import 'package:chatbot/ui/custom_paint/MetroLines.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:touchable/touchable.dart';


class TransportMenuButtons extends StatefulWidget{
  @override
  State<StatefulWidget> createState()=> TransportMenuStates();
}

class TransportMenuStates extends State<TransportMenuButtons> with SingleTickerProviderStateMixin{
  TabController _controller;
  @override
  void initState() {
    super.initState();
    _controller = new TabController(length: 2, vsync: this);
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
              _makeFuncButton(context, "셔틀", 0, "assets/images/shared/sheet-header-shuttle.png", 0.35, _shuttleSheets(context)),
              _makeFuncButton(context, "전철", 1, "assets/images/shared/sheet-header-metro.png", 0.65, _metroSheets(context)),
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

  Widget _shuttleSheets(BuildContext context){
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
              CanvasTouchDetector(
                builder:(context) => CustomPaint(
                  painter: ShuttleLanes("한대앞행", context, _result["DH"]), size: Size(MediaQuery.of(context).size.width, 75),),
              ),
              CanvasTouchDetector(
                builder: (context) => CustomPaint(
                  painter: ShuttleLanes("예술인행", context, _result["DY"]), size: Size(MediaQuery.of(context).size.width, 75),),
              ),
              CanvasTouchDetector(
                builder: (context) => CustomPaint(
                  painter: ShuttleLanes("순환버스", context, _result["C"]), size: Size(MediaQuery.of(context).size.width, 75),),
              ),
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

  Widget _metroSheets(BuildContext context){
    Timer.periodic(Duration(seconds: 60), (timer) {
      metroController.fetch();
    });

    return StreamBuilder<Map<String, dynamic>>(
        stream: metroController.allMetroInfo,
        builder: (context, snapshot) {
          if(snapshot.hasError || !snapshot.hasData){
            return CircularProgressIndicator();
          }
          else {
            return Scaffold(
              appBar: ColoredTabBar(
                  Theme.of(context).accentColor,
                  TabBar(
                    controller: _controller,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicatorColor: Colors.white,
                    indicatorWeight: 5,
                    indicatorPadding: EdgeInsets.symmetric(horizontal: 20),
                    labelColor: Colors.white,
                    tabs: [
                      const Tab(child: Text("4호선", style: TextStyle(fontSize: 19, fontFamily: "Noto Sans KR", color: Colors.white, fontWeight: FontWeight.bold)), ),
                      const Tab(child: Text("수인분당선", style: TextStyle(fontSize: 19, fontFamily: "Noto Sans KR", color: Colors.white, fontWeight: FontWeight.bold)),)
                    ],
                  )
              ),
              body: Container(
                color: Theme.of(context).accentColor,
                child: TabBarView(
                  controller: _controller,
                  children: [
                    Column(
                      children: [
                        CustomPaint(painter: MetroLanesRealtime(true, Color.fromRGBO(0, 165, 222, 1), ["안산", "초지", "고잔", "중앙", "한대앞"], snapshot.data['main']['up']), size: Size(MediaQuery.of(context).size.width, 200),),
                        CustomPaint(painter: MetroLanesRealtime(false, Color.fromRGBO(0, 165, 222, 1), ["한대앞", "상록수", "반월", "대야미", "수리산"], snapshot.data['main']['down']), size: Size(MediaQuery.of(context).size.width, 200)),
                      ],
                    ),
                    Column(
                      children: [
                        CustomPaint(painter: MetroLanesTimeTable(true, Color.fromRGBO(245, 163, 0, 1), ["안산", "초지", "고잔", "중앙", "한대앞"], snapshot.data['sub']['up']), size: Size(MediaQuery.of(context).size.width, 200),),
                        CustomPaint(painter: MetroLanesTimeTable(false, Color.fromRGBO(245, 163, 0, 1), ["한대앞", "사리", "야목", "어천", "오목천"], snapshot.data['sub']['down']), size: Size(MediaQuery.of(context).size.width, 200)),
                      ],
                    ),
                ]),
              ),
            );
          }
        }
    );
  }
}