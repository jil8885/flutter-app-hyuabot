import 'package:flutter/material.dart';
import 'package:flutter_app_hyuabot_v2/Bloc/BusController.dart';
import 'package:flutter_app_hyuabot_v2/Config/GlobalVars.dart';
import 'package:flutter_app_hyuabot_v2/Config/Localization.dart';

class BusTimeTablePage extends StatefulWidget {
  final String lineName;
  final Color lineColor;

  BusTimeTablePage(this.lineName, this.lineColor);
  @override
  State<StatefulWidget> createState() => BusTimeTablePageState(lineName, lineColor);
}

class BusTimeTablePageState extends State<BusTimeTablePage>{
  final String lineName;
  final Color lineColor;

  final FetchBusInfoController _busController = FetchBusInfoController();
  final Map<String, Map<String, dynamic>> lineInfo = {
    "10-1":{"estimated": 10, "from": "purgio_apt", "to": "sangnoksu_stn", "weekdays":"15~30", "weekends":"25~50"},
    "3102":{"estimated": 30, "from": "songsan", "to": "gangnam_stn", "weekdays":"10~30", "weekends":"20~40"},
  };

  BusTimeTablePageState(this.lineName, this.lineColor);

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
          TextStyle _timeColor = TextStyle(color: Theme.of(context).textTheme.bodyText1.color, fontSize: 24);
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
    TranslationManager _manager = TranslationManager.of(context);
    String _minuteInfo= "";
    switch (prefManager.getString("localeCode")){
      case "ko_KR":
        _minuteInfo = "평일: ${lineInfo[lineName]["weekdays"]} 분/주말: ${lineInfo[lineName]["weekends"]} 분";
        break;
      case "en_US":
        _minuteInfo = "Weekdays: ${lineInfo[lineName]["weekdays"]} min/Weekends: ${lineInfo[lineName]["weekends"]} min";
        break;
      case "zh":
        break;
    }

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
                    Text("${TranslationManager.of(context).trans(lineInfo[lineName]["from"])} → ${TranslationManager.of(context).trans(lineInfo[lineName]["to"])}", style: TextStyle(color: Colors.white, fontSize: 18)),
                    SizedBox(height: 10,),
                    Text(_minuteInfo, style: TextStyle(color: Colors.white, fontSize: 18)),
                  ],
                ),
              ],
            ),
            color: lineColor,
          ),
          StreamBuilder<Map<String, dynamic>>(
            stream: _busController.timetableInfo,
            builder: (context, snapshot) {
              if(snapshot.hasError || !snapshot.hasData){
                return Expanded(child: Center(child: CircularProgressIndicator(),));
              }
              int initialIndex = 0;
              switch(snapshot.data["day"]){
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
                        Tab(child: Text(_manager.trans("weekdays"), style: Theme.of(context).textTheme.bodyText1,),),
                        Tab(child: Text(_manager.trans("saturday"), style: Theme.of(context).textTheme.bodyText1,),),
                        Tab(child: Text(_manager.trans("sunday"), style: Theme.of(context).textTheme.bodyText1,),),
                      ],),
                      Expanded(child: TabBarView(
                        children: [
                          Container(child: _timeTableView(snapshot.data["weekdays"], 0, initialIndex)),
                          Container(child: _timeTableView(snapshot.data["saturday"], 1, initialIndex)),
                          Container(child: _timeTableView(snapshot.data["sunday"], 2, initialIndex)),
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

  @override
  void initState() {
    _busController.fetchTimeTable(lineName);
    super.initState();
  }
  @override
  void dispose() {
    _busController.dispose();
    super.dispose();
  }
}