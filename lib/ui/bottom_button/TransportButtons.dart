import 'dart:async';


import 'package:chatbot/config/style.dart';
import 'package:chatbot/main.dart';
import 'package:chatbot/config/common.dart';
import 'package:chatbot/model/Shuttle.dart';
import 'package:chatbot/ui/bottom_sheet/TransportSheets.dart';
import 'package:chatbot/ui/custom_paint/BusLines.dart';
import 'package:chatbot/ui/custom_paint/ShuttleLines.dart';
import 'package:chatbot/ui/custom_paint/MetroLines.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:touchable/touchable.dart';


class TransportMenuButtons extends StatefulWidget{
  @override
  State<StatefulWidget> createState()=> TransportMenuStates();
}

class TransportMenuStates extends State<TransportMenuButtons> with TickerProviderStateMixin{
  TabController _metroController;
  TabController _busController;
  Timer timer;

  @override
  void initState() {
    super.initState();
    _metroController = new TabController(length: 2, vsync: this);
    _busController = new TabController(length: 3, vsync: this);
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
              _makeFuncButton(context, "노선버스", 2, "assets/images/shared/sheet-header-bus.png", 0.65, _busSheets(context)),
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
              timer.cancel();
              switch(index){
                case 0:
                  allShuttleController.fetch();
                  shuttleSheetOpened = true;
                  metroSheetOpened = false;
                  busSheetOpened = false;
                  break;
                case 1:
                  metroController.fetch();
                  shuttleSheetOpened = false;
                  metroSheetOpened = true;
                  busSheetOpened = false;
                  break;
                case 2:
                  busController.fetch();
                  shuttleSheetOpened = false;
                  metroSheetOpened = false;
                  busSheetOpened = true;
                  break;
              }
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
    timer = Timer.periodic(Duration(seconds: 60), (timer) {
      if(shuttleSheetOpened) {
        allShuttleController.fetch();
      }
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
    timer = Timer.periodic(Duration(seconds: 60), (timer) {
      if(metroSheetOpened){
        metroController.fetch();
      }
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
                    controller: _metroController,
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
                  controller: _metroController,
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


  Widget _busSheets(BuildContext context){
    timer = Timer.periodic(Duration(seconds: 60), (timer) {
      if(busSheetOpened){
        busController.fetch();
      }
    });

    return StreamBuilder<Map<String, dynamic>>(
        stream: busController.allBusInfo,
        builder: (context, snapshot) {
          if(snapshot.hasError || !snapshot.hasData){
            return CircularProgressIndicator();
          }
          else {
            return Scaffold(
              appBar: ColoredTabBar(
                  Theme.of(context).accentColor,
                  TabBar(
                    controller: _busController,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicatorColor: Colors.white,
                    indicatorWeight: 5,
                    indicatorPadding: EdgeInsets.symmetric(horizontal: 20),
                    labelColor: Colors.white,
                    tabs: [
                      const Tab(child: Text("10-1", style: TextStyle(fontSize: 19, fontFamily: "Noto Sans KR", color: Colors.white, fontWeight: FontWeight.bold)), ),
                      const Tab(child: Text("3102", style: TextStyle(fontSize: 19, fontFamily: "Noto Sans KR", color: Colors.white, fontWeight: FontWeight.bold)), ),
                      const Tab(child: Text("707-1", style: TextStyle(fontSize: 19, fontFamily: "Noto Sans KR", color: Colors.white, fontWeight: FontWeight.bold)),)
                    ],
                  )
              ),
              body: Container(
                color: Theme.of(context).accentColor,
                child: TabBarView(
                    controller: _busController,
                    children: [
                      Container(child: CustomPaint(painter: BusLanes(context, ["푸르지오6차후문", "해양중학교", "푸르지오6,7차정문", "경기테크노파크", "한양대기숙사앞", "한국생산기술연구원", "한양대게스트하우스"], snapshot.data["10-1"]["realtime"], snapshot.data["10-1"]["timetable"], "푸르지오6차후문"),),),
                      Container(child: CustomPaint(painter: BusLanes(context, ["푸르지오6차후문", "해양중학교", "푸르지오6,7차정문", "경기테크노파크", "한양대기숙사앞", "한국생산기술연구원", "한양대게스트하우스"], snapshot.data["3102"]["realtime"], snapshot.data["3102"]["timetable"], "송산그린시티"),),),
                      Container(child: CustomPaint(painter: BusLanes(context, ["홈플러스", "화승타운", "네오빌6단지", "송호초등학교", "고잔고", "고잔1차푸르지오", "한양대정문"], snapshot.data["707-1"]["realtime"], snapshot.data["707-1"]["timetable"], "신안산대학교"),),),
                    ]),
              ),
            );
          }
        }
    );
  }
}

