import 'package:flutter/material.dart';
import 'package:flutter_app_hyuabot_v2/Bloc/BusController.dart';
import 'package:flutter_app_hyuabot_v2/Config/Common.dart';
import 'package:flutter_app_hyuabot_v2/Config/GlobalVars.dart';
import 'package:flutter_app_hyuabot_v2/Config/Localization.dart';
import 'package:flutter_app_hyuabot_v2/Model/Bus.dart';

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

  Widget _timeTableView(List timeTable){
    return ListView.separated(
        itemBuilder: (context, index){
          return Container(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
            child: Container(
              width: MediaQuery.of(context).size.width*.5,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("${timeTable[index]["time"]}", style: TextStyle(color: Theme.of(context).textTheme.bodyText1.color, fontSize: 24)),
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
    switch (prefManager.getString("localeCode", defaultValue: "ko_KR").getValue()){
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
                    Text("${TranslationManager.of(context).trans(lineInfo[lineName]["from"])} → ${TranslationManager.of(context).trans(lineInfo[lineName]["to"])}", style: TextStyle(color: Theme.of(context).textTheme.bodyText1.color, fontSize: 18)),
                    SizedBox(height: 10,),
                    Text(_minuteInfo, style: TextStyle(color: Theme.of(context).textTheme.bodyText1.color, fontSize: 18)),
                  ],
                ),
              ],
            ),
            color: lineColor,
          ),
          Expanded(
            child: DefaultTabController(
              length: 3,
              child: Column(
                children: [
                  TabBar(tabs: [
                    Tab(child: Text(_manager.trans("weekdays"), style: Theme.of(context).textTheme.bodyText1,),),
                    Tab(child: Text(_manager.trans("saturday"), style: Theme.of(context).textTheme.bodyText1,),),
                    Tab(child: Text(_manager.trans("sunday"), style: Theme.of(context).textTheme.bodyText1,),),
                  ],),
                  StreamBuilder<Map<String, List<dynamic>>>(
                      stream: _busController.timetableInfo,
                      builder: (context, snapshot) {
                        if(snapshot.hasError || !snapshot.hasData){
                          return Expanded(child: Center(child: CircularProgressIndicator(),));
                        }
                        return Expanded(child: TabBarView(
                          children: [
                            Container(child: _timeTableView(snapshot.data["weekdays"]),),
                            Container(child: _timeTableView(snapshot.data["saturday"]),),
                            Container(child: _timeTableView(snapshot.data["sunday"]),),
                          ],
                        ));
                      }
                  )
                ],
              ),
            ),
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