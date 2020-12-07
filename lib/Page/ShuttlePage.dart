import 'dart:async';

import 'package:flutter_app_hyuabot_v2/Config/Localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app_hyuabot_v2/Bloc/ShuttleController.dart';
import 'package:flutter_app_hyuabot_v2/Model/Shuttle.dart';
import 'package:flutter_app_hyuabot_v2/UI/CustomPaint/ShuttlePaint.dart';
import 'package:get/get.dart';

class ShuttlePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ShuttlePageState();

}
class _ShuttlePageState extends State<ShuttlePage>{
  FetchAllShuttleController _shuttleController;
  Timer _shuttleTimer;
  BuildContext _context;
  Widget _shuttleCard(double width, double height, String currentStop, String terminalStop, List timeTable, ShuttleStopDepartureInfo data){
    CustomPainter content = ShuttleCardPaint(timeTable, data, Color.fromARGB(255, 20, 75, 170), context);
    return InkWell(
      onTap: (){
        print(currentStop);
        print(terminalStop);
        },
      child: Card(
        color: Theme.of(_context).backgroundColor == Colors.white ? Colors.white : Colors.black,
        elevation: 3,
        child: Container(
          width: width * .9,
          padding: EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 10),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 5),
                child: Text(TranslationManager.of(_context).trans(currentStop), style: TextStyle(fontSize: 16, fontFamily: "Godo", color: Theme.of(_context).backgroundColor == Colors.white ? Colors.black : Colors.white,),),
              ),
              Text(TranslationManager.of(_context).trans(terminalStop), style: TextStyle(fontSize: 12, fontFamily: "Godo", color: Theme.of(_context).backgroundColor == Colors.white ? Colors.black : Colors.white,),),
              Divider(color: Colors.grey),
              Container(child: CustomPaint(painter: content, size: Size(100, 40),), padding: EdgeInsets.only(bottom: 10),)
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    _shuttleController = FetchAllShuttleController();
    _shuttleTimer = Timer.periodic(Duration(minutes: 1), (timer) {_shuttleController.fetch();});
    _context = context;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    final double _height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: StreamBuilder<Map<String, ShuttleStopDepartureInfo>>(
            stream: _shuttleController.allShuttleInfo,
            builder: (context, snapshot) {
              if(snapshot.hasError){
                return Center(child: Text(TranslationManager.of(context).trans("failed_to_load_shuttle"), style: Theme.of(context).textTheme.bodyText1,),);
              } else if(!snapshot.hasData){
                return Center(child: CircularProgressIndicator(),);
              }
              List<dynamic> residenceStn = List.from(snapshot.data["Residence"].shuttleListStation)..addAll(snapshot.data["Residence"].shuttleListCycle)..sort();
              List<dynamic> residenceTerminal = List.from(snapshot.data["Residence"].shuttleListTerminal)..addAll(snapshot.data["Residence"].shuttleListCycle)..sort();
              List<dynamic> schoolStn = List.from(snapshot.data["Shuttlecock_O"].shuttleListStation)..addAll(snapshot.data["Shuttlecock_O"].shuttleListCycle)..sort();
              List<dynamic> schoolTerminal = List.from(snapshot.data["Shuttlecock_O"].shuttleListTerminal)..addAll(snapshot.data["Shuttlecock_O"].shuttleListCycle)..sort();
              List<dynamic> station = List.from(snapshot.data["Subway"].shuttleListStation)..addAll(snapshot.data["Subway"].shuttleListCycle)..sort();
              List<dynamic> terminal = List.from(snapshot.data["YesulIn"].shuttleListTerminal)..addAll(snapshot.data["YesulIn"].shuttleListCycle)..sort();
              List<dynamic> schoolResidence = List.from(snapshot.data["Shuttlecock_I"].shuttleListStation)..addAll(snapshot.data["Shuttlecock_I"].shuttleListTerminal)..addAll(snapshot.data["Shuttlecock_I"].shuttleListCycle)..sort();
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(icon: Icon(Icons.arrow_back_rounded, color: Theme.of(context).textTheme.bodyText1.color,), onPressed: (){Get.back();}, padding: EdgeInsets.only(left: 20), alignment: Alignment.centerLeft,)
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _shuttleCard(_width / 2, _height, "bus_stop_dorm", "bound_bus_station", residenceStn, snapshot.data["Residence"]),
                        _shuttleCard(_width / 2, _height, "bus_stop_dorm", "bound_bus_terminal", residenceTerminal, snapshot.data["Residence"]),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _shuttleCard(_width / 2, _height, "bus_stop_school", "bound_bus_station", schoolStn, snapshot.data["Shuttlecock_O"]),
                        _shuttleCard(_width / 2, _height, "bus_stop_school", "bound_bus_terminal", schoolTerminal, snapshot.data["Shuttlecock_O"]),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _shuttleCard(_width / 2, _height, "bus_stop_station", "bound_bus_school", station, snapshot.data["Subway"]),
                        _shuttleCard(_width / 2, _height, "bus_stop_terminal", "bound_bus_school", terminal, snapshot.data["YesulIn"]),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _shuttleCard(_width / 2, _height, "bus_stop_school_opposite", "bound_bus_dorm", schoolResidence, snapshot.data["Shuttlecock_I"]),
                      ],
                    ),
                    Expanded(child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Center(child: Text(TranslationManager.of(context).trans("touch_shuttle_timetable"), textAlign: TextAlign.center, style: TextStyle(color: Colors.grey),),)],
                    ),),
                  ],
                ),
              );
            }
        ),
      ),
    );
  }

  @override
  void dispose() {
    _shuttleTimer.cancel();
    _shuttleController.dispose();
    super.dispose();
  }
}