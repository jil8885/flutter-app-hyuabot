import 'package:flutter/material.dart';
import 'package:flutter_app_hyuabot_v2/Bloc/BusController.dart';
import 'package:flutter_app_hyuabot_v2/Config/GlobalVars.dart';
import 'package:get/get.dart';

class BusTimeTablePage extends StatelessWidget {
  final String lineName;
  final Color lineColor;

  BusTimeTablePage(this.lineName, this.lineColor);

  final Map<String, Map<String, dynamic>> lineInfo = {
    "10-1":{"estimated": 10, "from": "purgio_apt", "to": "sangnoksu_stn", "weekdays":"15~30", "weekends":"25~50"},
    "3102":{"estimated": 30, "from": "songsan", "to": "gangnam_stn", "weekdays":"10~30", "weekends":"20~40"},
  };

  Widget _timeTableView(List timeTable, int order, int initialIndex){
    DateTime now = DateTime.now();
    bool passed;
    return ListView.separated(
        itemBuilder: (context, index){
          passed=true;
          var time = timeTable[index]["time"].toString().split(":");
          int hour = int.parse(time[0]);
          int minute = int.parse(time[1]);
          if(hour > now.hour || (hour == now.hour && minute > now.minute)){
            passed = false;
          }

          if(index > 0){
            time = timeTable[index - 1]["time"].toString().split(":");
            hour = int.parse(time[0]);
            minute = int.parse(time[1]);
            if(hour > now.hour || (hour == now.hour && minute > now.minute)){
              passed = true;
            }
          }

          Color _rowColor;
          TextStyle _timeColor = TextStyle(color: Theme.of(context).textTheme.bodyText2.color, fontSize: 24);
          if(!passed && (initialIndex == order)){
            _rowColor = Color.fromARGB(255, 20, 75, 170);
            _timeColor = TextStyle(color: Colors.white, fontSize: 24);
          } else if(passed  && (initialIndex == order) && (hour < now.hour || (hour == now.hour && minute <= now.minute))){
            _timeColor = TextStyle(color: Colors.grey, fontSize: 24);
          }

          return Container(
            color: _rowColor,
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
            child: Container(
              width: MediaQuery.of(context).size.width*.5,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("${timeTable[index]["time"]}", style: _timeColor),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (context, index) => Divider(height: .5, indent: 15, color: Color(0xFFDDDDDD),),
        itemCount: timeTable.length
    );
  }

  @override
  Widget build(BuildContext context) {
    analytics.setCurrentScreen(screenName: "/bus/timetable");
    String _minuteInfo= "";
    final BusTimetableController _busController = Get.put(BusTimetableController(lineName));


    switch (prefManager.read("localeCode")){
      case "ko_KR":
        _minuteInfo = "평일: ${lineInfo[lineName]["weekdays"]} 분/주말: ${lineInfo[lineName]["weekends"]} 분";
        break;
      case "en_US":
        _minuteInfo = "Weekdays: ${lineInfo[lineName]["weekdays"]} min/Weekends: ${lineInfo[lineName]["weekends"]} min";
        break;
      case "zh":
        break;
    }

    String _startStop = lineInfo[lineName]["from"].toString().tr;
    String _terminalStop = lineInfo[lineName]["to"].toString().tr;
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            height: 200,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(lineName, style: TextStyle(color: Colors.white, fontSize: 28)),
                    SizedBox(height: 30,),
                    Text("$_startStop → $_terminalStop", style: TextStyle(color: Colors.white, fontSize: 18)),
                    SizedBox(height: 10,),
                    Text(_minuteInfo, style: TextStyle(color: Colors.white, fontSize: 18)),
                  ],
                ),
              ],
            ),
            color: lineColor,
          ),
          Obx(() {
              if(_busController.isLoading.value){
                return Expanded(child: Center(child: CircularProgressIndicator(),));
              }
              int initialIndex = 0;
              switch(_busController.timetableInfo["day"]){
                case "weekdays":
                  initialIndex = 0;
                  break;
                case "sat":
                  initialIndex = 1;
                  break;
                case "sun":
                  initialIndex = 2;
                  break;
              }
              return Expanded(
                child: DefaultTabController(
                  length: 3,
                  initialIndex: initialIndex,
                  child: Column(
                    children: [
                      TabBar(tabs: [
                        Tab(child: Text("weekdays".tr, style: Theme.of(context).textTheme.bodyText2,),),
                        Tab(child: Text("saturday".tr, style: Theme.of(context).textTheme.bodyText2,),),
                        Tab(child: Text("sunday".tr, style: Theme.of(context).textTheme.bodyText2,),),
                      ],),
                      Expanded(child: TabBarView(
                        children: [
                          Container(child: _timeTableView(_busController.timetableInfo["weekdays"], 0, initialIndex)),
                          Container(child: _timeTableView(_busController.timetableInfo["saturday"], 1, initialIndex)),
                          Container(child: _timeTableView(_busController.timetableInfo["sunday"], 2, initialIndex)),
                        ],
                      ))
                    ],
                  ),
                ),
              );
            }
          ),
        ],
      ),
    );
  }
}