import 'dart:async';

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

  Widget _shuttleCard(double width, double height, String currentStop, String terminalStop, List timeTable, ShuttleStopDepartureInfo data){
    CustomPainter content = ShuttleCardPaint(timeTable, data, Color.fromARGB(255, 20, 75, 170), context);
    return Card(
      color: Colors.white,
      elevation: 3,
      child: Container(
        width: width * .9,
        height: height / 5.5,
        padding: EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 10),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 5),
              child: Text(currentStop, style: TextStyle(fontSize: 16, fontFamily: "Godo", color: Colors.black),),
            ),
            Text("$terminalStop 방면", style: TextStyle(fontSize: 12, fontFamily: "Godo", color: Colors.grey),),
            Divider(color: Colors.grey),
            Container(child: CustomPaint(painter: content,), padding: EdgeInsets.only(bottom: 10),)
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    _shuttleController = FetchAllShuttleController();
    _shuttleTimer = Timer.periodic(Duration(minutes: 1), (timer) {_shuttleController.fetch();});
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
                return Center(child: Text("셔틀 정보를 불러오는데 실패했습니다.", style: Theme.of(context).textTheme.bodyText1,),);
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
                        _shuttleCard(_width / 2, _height, "기숙사", "한대앞역", residenceStn, snapshot.data["Residence"]),
                        _shuttleCard(_width / 2, _height, "기숙사", "예술인A", residenceTerminal, snapshot.data["Residence"]),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _shuttleCard(_width / 2, _height, "셔틀콕", "한대앞역", schoolStn, snapshot.data["Shuttlecock_O"]),
                        _shuttleCard(_width / 2, _height, "셔틀콕", "예술인A", schoolTerminal, snapshot.data["Shuttlecock_O"]),
                      ],
                    ),                      Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _shuttleCard(_width / 2, _height, "한대앞역", "셔틀콕·기숙사", station, snapshot.data["Subway"]),
                        _shuttleCard(_width / 2, _height, "예술인A", "셔틀콕·기숙사", terminal, snapshot.data["YesulIn"]),
                      ],
                    ),                      Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _shuttleCard(_width / 2, _height, "셔틀콕 건너편", "기숙사", schoolResidence, snapshot.data["Shuttlecock_I"]),
                      ],
                    ),
                    Expanded(child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Center(child: Text("터치하면 전체 시간표를 볼 수 있습니다.", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey),),)],
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