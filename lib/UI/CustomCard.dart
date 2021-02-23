import 'package:flutter/material.dart';
import 'package:flutter_app_hyuabot_v2/Model/Store.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

import 'package:flutter_app_hyuabot_v2/Config/Common.dart';
import 'package:flutter_app_hyuabot_v2/Model/FoodMenu.dart';
import 'package:flutter_app_hyuabot_v2/Model/Shuttle.dart';


class CustomShuttleCard extends StatelessWidget {

  final String title;
  final List<String> timetable;
  final ShuttleStopDepartureInfo data;

  CustomShuttleCard({this.title, this.timetable, this.data});

  @override
  Widget build(BuildContext context) {
    double _width;

    _width= MediaQuery.of(context).size.width;

    var remainedTimeString = "";
    var thisBusString = "";
    var nextBusString = "";

    Widget _remainedText;


    if(timetable.length >= 2){
      DateTime thisBus = getTimeFromString(timetable.elementAt(0), DateTime.now());
      remainedTimeString = '${thisBus.difference(DateTime.now()).inMinutes}';
      thisBusString = "${"this_bus".tr()} : ${timetable.elementAt(0)}";
      if(data.shuttleListCycle.contains(timetable.elementAt(0))){
        thisBusString += "(${"is_cycle".tr()})";
      } else if(data.shuttleListStation.contains(timetable.elementAt(0)) || data.shuttleListTerminal.contains(timetable.elementAt(0))){
        thisBusString += "(${"is_direct".tr()})";
      }
      nextBusString = "${"next_bus".tr()} : ${timetable.elementAt(1)}";
      if(data.shuttleListCycle.contains(timetable.elementAt(1))){
        nextBusString += "(${"is_cycle".tr()})";
      } else if(data.shuttleListStation.contains(timetable.elementAt(1)) || data.shuttleListTerminal.contains(timetable.elementAt(1))){
        nextBusString += "(${"is_direct".tr()})";
      }
    } else if(timetable.length == 1){
      DateTime thisBus = getTimeFromString(timetable.elementAt(0), DateTime.now());
      remainedTimeString = '${thisBus.difference(DateTime.now()).inMinutes}';
      thisBusString = "${"this_bus".tr()} : ${timetable.elementAt(0)}";
      if(data.shuttleListCycle.contains(timetable.elementAt(0))){
        thisBusString += "(${"is_cycle".tr()})";
      } else if(data.shuttleListStation.contains(timetable.elementAt(0)) || data.shuttleListTerminal.contains(timetable.elementAt(0))){
        thisBusString += "(${"is_direct".tr()})";
      }
      nextBusString = "is_last_bus".tr();
    } else {
      thisBusString = "out_of_service".tr();
    }

    if(timetable.isNotEmpty){
      String minString = 'min_after'.tr();
      if(minString.contains('min') && remainedTimeString == '1'){
        minString = 'min left'.tr();
      }
      _remainedText = Flexible(
        child: Container(width: _width / 2.5,
            child: Text.rich(
              TextSpan(children: [
                TextSpan(text: "$remainedTimeString ", style: TextStyle(fontSize: 22.5, color: Theme.of(context).backgroundColor == Colors.white? Colors.black : Colors.white, fontWeight: FontWeight.bold)),
                TextSpan(text: minString, style: TextStyle(fontSize: 18, color: Theme.of(context).backgroundColor == Colors.white? Colors.black : Colors.white),),
              ],),
            )),
      );
    } else {
      _remainedText = Flexible(
        child: Container(width: _width / 2.5,
            child: Text(remainedTimeString, style: TextStyle(fontSize: 22.5, color: Colors.black), maxLines: 1, overflow: TextOverflow.ellipsis, softWrap: true,)),
      );
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      color: Theme.of(context).cardColor,
      child: Container(
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(fontSize: 20, color: Theme.of(context).backgroundColor == Colors.white? Colors.black : Colors.white),
                ),
                SizedBox(
                  height: 10,
                ),
                _remainedText,
                Expanded(child: Container(),),
                Container(child: Text(thisBusString, style: TextStyle(fontSize: 15, color: Theme.of(context).backgroundColor == Colors.white? Colors.black : Colors.white), maxLines: 1, overflow: TextOverflow.ellipsis, softWrap: true,)),
                SizedBox(height: 5),
                Container(child: Text(nextBusString, style: TextStyle(fontSize: 15, color: Theme.of(context).backgroundColor == Colors.white? Colors.black : Colors.white), maxLines: 1, overflow: TextOverflow.ellipsis, softWrap: true,)),
              ],
            ),
            SizedBox(
              width: 10,
            ),
          ],
        ),
      ),
    );
  }
}

class CustomFoodCard extends StatelessWidget {
  final String title;
  final String time;
  final FoodMenu data;

  CustomFoodCard({this.title, this.time, this.data});

  @override
  Widget build(BuildContext context) {
    double _width;
    double _height;

    _width= MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;

    String _menu = "메뉴를 준비중입니다";
    String _price = "0";
    if(data == null){
      _menu = "menu_not_uploaded".tr();
    } else {
      _menu = data.menu;
      _price = data.price;
    }
    return Card(
      shape:
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      color: Theme.of(context).cardColor,
      child: Container(
        padding: EdgeInsets.all(16.0),
        width: _width * .75,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Text('$title($time)', style: TextStyle(fontSize: _height/40, color: Theme.of(context).backgroundColor == Colors.white? Colors.black : Colors.white),),
            SizedBox(height: 20,),
            Text(_menu, style: TextStyle(fontSize: _height/50, color: Theme.of(context).backgroundColor == Colors.white? Colors.black : Colors.white),),
            Flexible(child: Container(),),
            Text('$_price ${"menu_price".tr()}', style: TextStyle(fontSize: _height/50, fontWeight: FontWeight.bold, color: Theme.of(context).backgroundColor == Colors.white ? Color.fromARGB(255, 20, 75, 170) : Colors.lightBlue),)
          ],
        ),
      )
    );
  }
}

class CustomStoreCard extends StatelessWidget {

  final StoreInfo info;
  CustomStoreCard(this.info);

  @override
  Widget build(BuildContext context) {
    double _height;
    _height = MediaQuery.of(context).size.height;

    Widget _callButton;
    if(info.number != null){
      _callButton = Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RaisedButton(
            onPressed: (){
              UrlLauncher.launch("tel://${info.number}");
            },
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Icon(Icons.call_made_rounded),
                SizedBox(width: 5,),
                Text("map_can_call".tr()),
              ],
            ), ),
        ],
      );
    } else {
      _callButton = Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RaisedButton(
            onPressed: null,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Icon(Icons.call_made_rounded),
                SizedBox(width: 5,),
                Text("map_cant_call".tr()),
              ],
            ),
          ),
        ],
      );
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      color: Theme.of(context).backgroundColor == Colors.white? Colors.white : Colors.black87,
      child: Container(
        padding: EdgeInsets.only(left: 18, top: 10, right: 18, bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  info.name,
                  style: TextStyle(fontSize: _height/40, color: Theme.of(context).backgroundColor == Colors.white? Colors.black : Colors.white),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(info.menu, style: TextStyle(fontSize: _height/50, color: Theme.of(context).backgroundColor == Colors.white? Colors.black : Colors.white), maxLines: 1, overflow: TextOverflow.ellipsis, softWrap: true,),
                SizedBox(height: 10,),
                Expanded(child: _callButton)
              ],
            ),
          ],
        ),
      ),
    );
  }
}