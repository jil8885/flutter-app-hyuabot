import 'dart:async';


import 'package:chatbot/config/Localization.dart';
import 'package:chatbot/config/Style.dart';
import 'package:chatbot/main.dart';
import 'package:chatbot/config/Common.dart';
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

  @override
  void initState() {
    super.initState();
    _metroController = new TabController(length: 2, vsync: this);
    _busController = new TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final _shuttleSheet = TransportSheets("assets/images/shared/sheet-header-shuttle.png", _shuttleSheets(context), 0.35);
    final _metroSheet = TransportSheets("assets/images/shared/sheet-header-metro.png", _metroSheets(context), 0.65);
    final _busSheet = TransportSheets("assets/images/shared/sheet-header-bus.png", _busSheets(context), 0.55);
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        backMenuButton(context),
        Flexible(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _makeFuncButton(context, Translations.of(context).trans("shuttle_btn"), 0, _shuttleSheet, allShuttleController, 60),
              _makeFuncButton(context, Translations.of(context).trans("metro_btn"), 1, _metroSheet, metroController, 60),
              _makeFuncButton(context, Translations.of(context).trans("bus_btn"), 2, _busSheet, busController, 60),
            ],
          ),
        ),
      ],
    );
  }

  Widget _makeFuncButton(BuildContext context, String buttonText, int index, Widget contents, controller, int second){
    contents ??= Container();
    timer = Timer.periodic(Duration(seconds: second), (timer) {
      controller.fetch();
    });
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
              subButtonController.updateSubButtonIndex(index);
              showMaterialModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  duration: Duration(milliseconds: 500),
                  builder: (context, scrollController) => contents);
            },
          ),
        );
      }
    );
  }

  Widget _shuttleSheets(BuildContext context){
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
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CustomPaint(painter: ShuttleStops(context), size: Size(MediaQuery.of(context).size.width, 30)),
              CanvasTouchDetector(
                builder:(context) => CustomPaint(
                  painter: ShuttleLanes(Translations.of(context).trans('bound_station'), context, _result["DH"]), size: Size(MediaQuery.of(context).size.width, 75),),
              ),
              CanvasTouchDetector(
                builder: (context) => CustomPaint(
                  painter: ShuttleLanes(Translations.of(context).trans('bound_terminal'), context, _result["DY"]), size: Size(MediaQuery.of(context).size.width, 75),),
              ),
              CanvasTouchDetector(
                builder: (context) => CustomPaint(
                  painter: ShuttleLanes(Translations.of(context).trans('bound_cycle'), context, _result["C"]), size: Size(MediaQuery.of(context).size.width, 75),),
              ),
            ],
          );
        }
      }
    );
  }

  Widget _metroSheets(BuildContext context){
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
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CustomPaint(painter: MetroLanesRealtime(true, Color.fromRGBO(0, 165, 222, 1), ["안산", "초지", "고잔", "중앙", "한대앞"], snapshot.data['main']['up']), size: Size(MediaQuery.of(context).size.width, 200),),
                        CustomPaint(painter: MetroLanesRealtime(false, Color.fromRGBO(0, 165, 222, 1), ["한대앞", "상록수", "반월", "대야미", "수리산"], snapshot.data['main']['down']), size: Size(MediaQuery.of(context).size.width, 200)),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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

