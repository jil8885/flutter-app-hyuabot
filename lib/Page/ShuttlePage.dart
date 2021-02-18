import 'package:flutter_app_hyuabot_v2/Config/GlobalVars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app_hyuabot_v2/Model/Shuttle.dart';
import 'package:flutter_app_hyuabot_v2/Page/ShuttleTimeTablePage.dart';
import 'package:flutter_app_hyuabot_v2/UI/CustomPaint/ShuttlePaint.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:transition/transition.dart';

class ShuttlePage extends StatelessWidget {
  Widget _shuttleCard(BuildContext context, double width, double height, String currentStop, String terminalStop, List timeTable, ShuttleStopDepartureInfo data){
    CustomPainter content = ShuttleCardPaint(context, timeTable, data, Color.fromARGB(255, 20, 75, 170));
    return InkWell(
      onTap: (){
        Navigator.push(context, Transition(
            child: ShuttleTimeTablePage(currentStop, terminalStop),
          transitionEffect: TransitionEffect.leftToRight
        ).builder());
      },
      child: Card(
        color: Theme.of(context).backgroundColor == Colors.white ? Colors.white : Colors.black,
        elevation: 3,
        child: Container(
          width: width * .9,
          padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 5),
                child: Text(currentStop.tr(), style: TextStyle(fontSize: 16, color: Theme.of(context).backgroundColor == Colors.white ? Colors.black : Colors.white,),),
              ),
              Text(terminalStop.tr(), style: TextStyle(fontSize: 12, color: Theme.of(context).backgroundColor == Colors.white ? Colors.black : Colors.white,),),
              Divider(color: Colors.grey),
              Container(child: CustomPaint(painter: content, size: Size(100, 40),), padding: EdgeInsets.only(bottom: 10),)
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    analytics.setCurrentScreen(screenName: "/shuttle");
    final double _width = MediaQuery.of(context).size.width;
    final double _height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(icon: Icon(Icons.arrow_back_rounded, color: Theme.of(context).textTheme.bodyText2.color,), onPressed: (){Navigator.pop(context);}, padding: EdgeInsets.only(left: 20), alignment: Alignment.centerLeft,)
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                  child: StreamBuilder(
                    stream: shuttleDepartureController.departureInfo,
                    builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                      if(snapshot.hasError || !snapshot.hasData){
                        return CircularProgressIndicator();
                      }
                      List<dynamic> residenceStn = List.from(snapshot.data["Residence"].shuttleListStation)..addAll(snapshot.data["Residence"].shuttleListCycle)..sort();
                      List<dynamic> residenceTerminal = List.from(snapshot.data["Residence"].shuttleListTerminal)..addAll(snapshot.data["Residence"].shuttleListCycle)..sort();
                      List<dynamic> schoolStn = List.from(snapshot.data["Shuttlecock_O"].shuttleListStation)..addAll(snapshot.data["Shuttlecock_O"].shuttleListCycle)..sort();
                      List<dynamic> schoolTerminal = List.from(snapshot.data["Shuttlecock_O"].shuttleListTerminal)..addAll(snapshot.data["Shuttlecock_O"].shuttleListCycle)..sort();
                      List<dynamic> station = List.from(snapshot.data["Subway"].shuttleListStation)..addAll(snapshot.data["Subway"].shuttleListCycle)..sort();
                      List<dynamic> terminal = List.from(snapshot.data["YesulIn"].shuttleListTerminal)..addAll(snapshot.data["YesulIn"].shuttleListCycle)..sort();
                      List<dynamic> schoolResidence = List.from(snapshot.data["Shuttlecock_I"].shuttleListStation)..addAll(snapshot.data["Shuttlecock_I"].shuttleListTerminal)..addAll(snapshot.data["Shuttlecock_I"].shuttleListCycle)..sort();
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _shuttleCard(context, _width / 2, _height, "bus_stop_dorm", "bound_bus_station", residenceStn, snapshot.data["Residence"]),
                              _shuttleCard(context, _width / 2, _height, "bus_stop_dorm", "bound_bus_terminal", residenceTerminal, snapshot.data["Residence"]),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _shuttleCard(context, _width / 2, _height, "bus_stop_school", "bound_bus_station", schoolStn, snapshot.data["Shuttlecock_O"]),
                              _shuttleCard(context, _width / 2, _height, "bus_stop_school", "bound_bus_terminal", schoolTerminal, snapshot.data["Shuttlecock_O"]),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _shuttleCard(context, _width / 2, _height, "bus_stop_station", "bound_bus_school", station, snapshot.data["Subway"]),
                              _shuttleCard(context, _width / 2, _height, "bus_stop_terminal", "bound_bus_school", terminal, snapshot.data["YesulIn"]),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _shuttleCard(context, _width / 2, _height, "bus_stop_school_opposite", "bound_bus_dorm", schoolResidence, snapshot.data["Shuttlecock_I"]),
                            ],
                          ),
                          Container(
                            height: 80,
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [Center(child: Text("touch_shuttle_timetable".tr(), textAlign: TextAlign.center, style: TextStyle(color: Colors.grey),),)],
                            ),),
                        ],
                      );
                    },
                  )
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}