import 'package:flutter_app_hyuabot_v2/Config/GlobalVars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app_hyuabot_v2/Bloc/ShuttleController.dart';
import 'package:flutter_app_hyuabot_v2/Model/Shuttle.dart';
import 'package:flutter_app_hyuabot_v2/Page/ShuttleTimeTablePage.dart';
import 'package:flutter_app_hyuabot_v2/UI/CustomPaint/ShuttlePaint.dart';
import 'package:get/get.dart';

class ShuttlePage extends StatelessWidget {
  Widget _shuttleCard(double width, double height, String currentStop, String terminalStop, List timeTable, ShuttleStopDepartureInfo data){
    CustomPainter content = ShuttleCardPaint(timeTable, data, Color.fromARGB(255, 20, 75, 170));
    return InkWell(
      onTap: (){
        Get.to(ShuttleTimeTablePage(currentStop, terminalStop));
      },
      child: Card(
        color: !Get.isDarkMode ? Colors.white : Colors.black,
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
                child: Text(currentStop.tr, style: TextStyle(fontSize: 16, color: !Get.isDarkMode ? Colors.black : Colors.white,),),
              ),
              Text(terminalStop.tr, style: TextStyle(fontSize: 12, color: !Get.isDarkMode ? Colors.black : Colors.white,),),
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
                IconButton(icon: Icon(Icons.arrow_back_rounded, color: Theme.of(context).textTheme.bodyText1.color,), onPressed: (){Get.back();}, padding: EdgeInsets.only(left: 20), alignment: Alignment.centerLeft,)
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                  child: GetBuilder<ShuttleDepartureController>(
                      builder: (controller) {
                        List<dynamic> residenceStn = List.from(controller.departureInfo["Residence"].shuttleListStation)..addAll(controller.departureInfo["Residence"].shuttleListCycle)..sort();
                        List<dynamic> residenceTerminal = List.from(controller.departureInfo["Residence"].shuttleListTerminal)..addAll(controller.departureInfo["Residence"].shuttleListCycle)..sort();
                        List<dynamic> schoolStn = List.from(controller.departureInfo["Shuttlecock_O"].shuttleListStation)..addAll(controller.departureInfo["Shuttlecock_O"].shuttleListCycle)..sort();
                        List<dynamic> schoolTerminal = List.from(controller.departureInfo["Shuttlecock_O"].shuttleListTerminal)..addAll(controller.departureInfo["Shuttlecock_O"].shuttleListCycle)..sort();
                        List<dynamic> station = List.from(controller.departureInfo["Subway"].shuttleListStation)..addAll(controller.departureInfo["Subway"].shuttleListCycle)..sort();
                        List<dynamic> terminal = List.from(controller.departureInfo["YesulIn"].shuttleListTerminal)..addAll(controller.departureInfo["YesulIn"].shuttleListCycle)..sort();
                        List<dynamic> schoolResidence = List.from(controller.departureInfo["Shuttlecock_I"].shuttleListStation)..addAll(controller.departureInfo["Shuttlecock_I"].shuttleListTerminal)..addAll(controller.departureInfo["Shuttlecock_I"].shuttleListCycle)..sort();
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _shuttleCard(_width / 2, _height, "bus_stop_dorm", "bound_bus_station", residenceStn, controller.departureInfo["Residence"]),
                                _shuttleCard(_width / 2, _height, "bus_stop_dorm", "bound_bus_terminal", residenceTerminal, controller.departureInfo["Residence"]),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _shuttleCard(_width / 2, _height, "bus_stop_school", "bound_bus_station", schoolStn, controller.departureInfo["Shuttlecock_O"]),
                                _shuttleCard(_width / 2, _height, "bus_stop_school", "bound_bus_terminal", schoolTerminal, controller.departureInfo["Shuttlecock_O"]),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _shuttleCard(_width / 2, _height, "bus_stop_station", "bound_bus_school", station, controller.departureInfo["Subway"]),
                                _shuttleCard(_width / 2, _height, "bus_stop_terminal", "bound_bus_school", terminal, controller.departureInfo["YesulIn"]),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _shuttleCard(_width / 2, _height, "bus_stop_school_opposite", "bound_bus_dorm", schoolResidence, controller.departureInfo["Shuttlecock_I"]),
                              ],
                            ),
                            Container(
                              height: 80,
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [Center(child: Text("touch_shuttle_timetable".tr, textAlign: TextAlign.center, style: TextStyle(color: Colors.grey),),)],
                            ),),
                          ],
                        );
                      }
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}