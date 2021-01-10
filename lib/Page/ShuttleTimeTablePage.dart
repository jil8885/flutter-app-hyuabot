import 'package:flutter/material.dart';
import 'package:flutter_app_hyuabot_v2/Bloc/ShuttleController.dart';
import 'package:flutter_app_hyuabot_v2/Config/Common.dart';
import 'package:flutter_app_hyuabot_v2/Config/Localization.dart';
import 'package:flutter_app_hyuabot_v2/Model/Shuttle.dart';

class ShuttleTimeTablePage extends StatefulWidget {
  final String currentStop;
  final String destination;

  ShuttleTimeTablePage(this.currentStop, this.destination);
  @override
  State<StatefulWidget> createState() => ShuttleTimeTablePageState(currentStop, destination);
}

class ShuttleTimeTablePageState extends State<ShuttleTimeTablePage>{
  final String currentStop;
  final String destination;
  final FetchAllShuttleController _shuttleController = FetchAllShuttleController();
  ShuttleTimeTablePageState(this.currentStop, this.destination);

  String _busStop;

  Map<String, List<dynamic>> _getTimetable(Map<String, dynamic> data){
    Map<String, List<dynamic>> _resultData = {};

    switch(destination){
      case "bound_bus_station":
        _resultData["weekdays"] = List.from(data["weekdays"].shuttleListStation)..addAll(data["weekdays"].shuttleListCycle)..sort();
        _resultData["weekends"] = List.from(data["weekends"].shuttleListStation)..addAll(data["weekends"].shuttleListCycle)..sort();
        break;
      case "bound_bus_terminal":
        _resultData["weekdays"] = List.from(data["weekdays"].shuttleListTerminal)..addAll(data["weekdays"].shuttleListCycle)..sort();
        _resultData["weekends"] = List.from(data["weekends"].shuttleListTerminal)..addAll(data["weekends"].shuttleListCycle)..sort();
        break;
      case "bound_bus_school":
        _resultData["weekdays"] = List.from(data["weekdays"].shuttleListStation)..addAll(data["weekdays"].shuttleListTerminal)..addAll(data["weekdays"].shuttleListCycle)..sort();
        _resultData["weekends"] = List.from(data["weekends"].shuttleListStation)..addAll(data["weekends"].shuttleListTerminal)..addAll(data["weekends"].shuttleListCycle)..sort();
        break;
      case "bound_bus_dorm":
        _resultData["weekdays"] = List.from(data["weekdays"].shuttleListStation)..addAll(data["weekdays"].shuttleListTerminal)..addAll(data["weekdays"].shuttleListCycle)..sort();
        _resultData["weekends"] = List.from(data["weekends"].shuttleListStation)..addAll(data["weekends"].shuttleListTerminal)..addAll(data["weekends"].shuttleListCycle)..sort();
        break;
    }

    return _resultData;
  }

  String _getTimeString(String time, int minutes){
    DateTime now = DateTime.now();
    DateTime arrivalTime = getTimeFromString(time, now).add(Duration(minutes: minutes));
    return "${arrivalTime.hour.toString().padLeft(2, "0")}:${arrivalTime.minute.toString().padLeft(2, "0")}";
  }

  Widget _timeTableView(List timeTable, ShuttleStopDepartureInfo data, bool isWeekend){
    DateTime now = DateTime.now();
    bool passed;
    return ListView.separated(
        itemBuilder: (context, index){
          passed=true;
          var time = timeTable[index].toString().split(":");
          int hour = int.parse(time[0]);
          int minute = int.parse(time[1]);
          if(hour > now.hour || (hour == now.hour && minute > now.minute)){
            passed = false;
          }

          if(index > 0){
            time = timeTable[index - 1].toString().split(":");
            hour = int.parse(time[0]);
            minute = int.parse(time[1]);
            if(hour > now.hour || (hour == now.hour && minute > now.minute)){
              passed = true;
            }
          }

          Color _rowColor;
          TextStyle _headingColor = TextStyle(color: Theme.of(context).textTheme.bodyText1.color, fontSize: 24);
          TextStyle _timeColor = TextStyle(color: Theme.of(context).textTheme.bodyText1.color, fontSize: 24);
          TextStyle _time2Color = TextStyle(color: Colors.grey, fontSize: 20);
          if(!passed && isWeekend){
            _rowColor = Color.fromARGB(255, 20, 75, 170);
            _headingColor = TextStyle(color: Colors.white, fontSize: 24);
            _timeColor = TextStyle(color: Colors.white, fontSize: 24);
            _time2Color = TextStyle(color: Colors.white, fontSize: 20);
          }else if(passed  && isWeekend && (hour < now.hour || (hour == now.hour && minute <= now.minute))){
            _timeColor = TextStyle(color: Colors.grey, fontSize: 24);
          }

          String _label;
          int _minutes = 10;
          if(data.shuttleListCycle.contains(timeTable[index])){
            _label = "is_cycle";
            if(currentStop == "bus_stop_dorm"){
              if(destination == "bound_bus_station"){_minutes = 15;}
              else if (destination == "bound_bus_terminal"){_minutes = 20;}
            } else if(currentStop == "bus_stop_school" && destination == "bound_bus_terminal"){_minutes = 15;}
            else if(currentStop == "bus_stop_station"){_minutes = 15;}
            else if(currentStop == "bus_stop_school_opposite"){_minutes = 5;}
          }else{
            _label = "is_direct";
            if(currentStop == "bus_stop_dorm") {
              _minutes = 15;
            }
            else if(currentStop == "bus_stop_school_opposite"){_minutes = 5;}
          }

          return Container(
            padding: EdgeInsets.symmetric(vertical: 15),
            color: _rowColor,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(TranslationManager.of(context).trans(_label), style: _headingColor),
                Container(
                  width: MediaQuery.of(context).size.width*.5,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("${timeTable[index]} → ", style: _timeColor),
                      Text(_getTimeString(timeTable[index], _minutes), style: _time2Color),
                    ],
                  ),
                )
              ],
            ),
          );
        },
        separatorBuilder: (context, index) => Divider(height: .5, indent: 15, color: Color(0xFFDDDDDD),),
        itemCount: timeTable.length
    );
  }


  @override
  void initState() {
    switch(currentStop){
      case "bus_stop_dorm":
        _busStop = "Residence";
        break;
      case "bus_stop_school":
        _busStop = "Shuttlecock_O";
        break;
      case "bus_stop_station":
        _busStop = "Subway";
        break;
      case "bus_stop_terminal":
        _busStop = "YesulIn";
        break;
      case "bus_stop_school_opposite":
        _busStop = "Shuttlecock_I";
        break;
    }
    _shuttleController.fetchTimeTable(_busStop);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TranslationManager _manager = TranslationManager.of(context);
    return Scaffold(
     appBar: AppBar(
       title: Text("${_manager.trans(currentStop)} → ${_manager.trans(destination).replaceAll("Bound for", "")}"), centerTitle: true,
       backgroundColor: Color.fromARGB(255, 20, 75, 170),
     ),
     body: StreamBuilder<Map<String, dynamic>>(
       stream: _shuttleController.allTimeTableInfo,
       builder: (context, snapshot) {
         if(snapshot.hasError || !snapshot.hasData){
           return Center(child: CircularProgressIndicator(),);
         }
         Map<String, List<dynamic>> _data = _getTimetable(snapshot.data);
         int initialIndex = snapshot.data["day"] == "weekdays"? 0:1;
         return Container(
           child: DefaultTabController(
             length: 2,
             initialIndex: initialIndex,
             child: Column(
               children: [
                 TabBar(tabs: [Tab(child: Text(_manager.trans("weekdays"), style: Theme.of(context).textTheme.bodyText1,),), Tab(child: Text(_manager.trans("weekends"), style: Theme.of(context).textTheme.bodyText1,),)],),
                 Expanded(child: TabBarView(
                   children: [
                     Container(child: _timeTableView(_data["weekdays"], snapshot.data["weekdays"], snapshot.data["day"] == "weekdays"),),
                     Container(child: _timeTableView(_data["weekends"], snapshot.data["weekends"], snapshot.data["day"] != "weekdays"),),
                   ],
                 ))
               ],
             ),
           ),
         );
       }
     ),
   );
  }

  @override
  void dispose() {
    _shuttleController.dispose();
    super.dispose();
  }
}