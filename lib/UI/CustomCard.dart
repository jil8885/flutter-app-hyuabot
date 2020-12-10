import 'package:flutter/material.dart';
import 'package:flutter_app_hyuabot_v2/Bloc/DatabaseController.dart';
import 'package:flutter_app_hyuabot_v2/Config/Common.dart';
import 'package:flutter_app_hyuabot_v2/Config/Localization.dart';
import 'package:flutter_app_hyuabot_v2/Model/FoodMenu.dart';
import 'package:flutter_app_hyuabot_v2/Model/Shuttle.dart';

import 'package:url_launcher/url_launcher.dart' as UrlLauncher;


class CustomShuttleCard extends StatelessWidget {

  final String title;
  final List<String> timetable;
  final ShuttleStopDepartureInfo data;

  CustomShuttleCard({this.title, this.timetable, this.data});

  @override
  Widget build(BuildContext context) {
    double _width;
    double _height;

    _width= MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;

    String remainedTimeString = "";
    String thisBusString = "";
    String nextBusString = "";

    Widget _remainedText;


    if(timetable.length >= 2){
      DateTime thisBus = getTimeFromString(timetable.elementAt(0), DateTime.now());
      remainedTimeString = '${thisBus.difference(DateTime.now()).inMinutes}';
      thisBusString = "${TranslationManager.of(context).trans("this_bus")} : ${timetable.elementAt(0)}";
      if(data.shuttleListCycle.contains(timetable.elementAt(0))){
        thisBusString += "(${TranslationManager.of(context).trans("is_cycle")})";
      } else if(data.shuttleListStation.contains(timetable.elementAt(0)) || data.shuttleListTerminal.contains(timetable.elementAt(0))){
        thisBusString += "(${TranslationManager.of(context).trans("is_direct")})";
      }
      nextBusString = "${TranslationManager.of(context).trans("next_bus")} : ${timetable.elementAt(1)}";
      if(data.shuttleListCycle.contains(timetable.elementAt(1))){
        nextBusString += "(${TranslationManager.of(context).trans("is_cycle")})";
      } else if(data.shuttleListStation.contains(timetable.elementAt(1)) || data.shuttleListTerminal.contains(timetable.elementAt(1))){
        nextBusString += "(${TranslationManager.of(context).trans("is_direct")})";
      }
    } else if(timetable.length == 1){
      DateTime thisBus = getTimeFromString(timetable.elementAt(0), DateTime.now());
      remainedTimeString = '${thisBus.difference(DateTime.now()).inMinutes}';
      thisBusString = "${TranslationManager.of(context).trans("this_bus")} : ${timetable.elementAt(0)}";
      if(data.shuttleListCycle.contains(timetable.elementAt(0))){
        thisBusString += "(${TranslationManager.of(context).trans("is_cycle")})";
      } else if(data.shuttleListStation.contains(timetable.elementAt(0)) || data.shuttleListTerminal.contains(timetable.elementAt(0))){
        thisBusString += "(${TranslationManager.of(context).trans("is_direct")})";
      }
      nextBusString = TranslationManager.of(context).trans("is_last_bus");
    } else {
      thisBusString = TranslationManager.of(context).trans("out_of_service");
    }

    if(timetable.isNotEmpty){
      String minString = TranslationManager.of(context).trans('min_after');
      if(minString.contains('min') && remainedTimeString == '1'){
        minString = 'min left';
      }
      _remainedText = Flexible(
        child: Container(width: _width / 2.5,
            child: Text.rich(
              TextSpan(children: [
                TextSpan(text: "$remainedTimeString ", style: TextStyle(fontSize: _height/30, fontFamily: 'Godo', color: Theme.of(context).backgroundColor == Colors.white? Colors.black : Colors.white, fontWeight: FontWeight.bold)),
                TextSpan(text: minString, style: TextStyle(fontSize: _height/45, fontFamily: 'Godo', color: Theme.of(context).backgroundColor == Colors.white? Colors.black : Colors.white),),
              ],),
            )),
      );
    } else {
      _remainedText = Flexible(
        child: Container(width: _width / 2.5,
            child: Text(remainedTimeString, style: TextStyle(fontSize: _height/30, fontFamily: 'Godo', color: Colors.black), maxLines: 1, overflow: TextOverflow.ellipsis, softWrap: true,)),
      );
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      color: Theme.of(context).backgroundColor == Colors.white? Colors.white : Colors.black87,
      child: Container(
        padding: EdgeInsets.only(left: 18, top: 10, right: 18, bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(fontSize: _height/40, fontFamily: 'Godo', color: Theme.of(context).backgroundColor == Colors.white? Colors.black : Colors.white),
                ),
                SizedBox(
                  height: 10,
                ),
                _remainedText,
                SizedBox(height: 25,),
                Container(width: _width / 2.5,
                    child: Text(thisBusString, style: TextStyle(fontSize: _height/50, fontFamily: 'Godo', color: Theme.of(context).backgroundColor == Colors.white? Colors.black : Colors.white), maxLines: 1, overflow: TextOverflow.ellipsis, softWrap: true,)
                ),
                SizedBox(height: 5),
                Container(width: _width / 2.5,
                    child: Text(nextBusString, style: TextStyle(fontSize: _height/50, fontFamily: 'Godo', color: Theme.of(context).backgroundColor == Colors.white? Colors.black : Colors.white), maxLines: 1, overflow: TextOverflow.ellipsis, softWrap: true,)),
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
      _menu = TranslationManager.of(context).trans("menu_not_uploaded");
    } else {
      _menu = data.menu;
      _price = data.price;
    }
    return Card(
      shape:
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      color: Theme.of(context).backgroundColor == Colors.white? Colors.white : Colors.black87,
      child: Container(
        padding: EdgeInsets.only(left: 10, top: 10, right: 5, bottom: 10),
        width: _width * .75,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Text('$title($time)', style: TextStyle(fontSize: _height/40, fontFamily: 'Godo', color: Theme.of(context).backgroundColor == Colors.white? Colors.black : Colors.white),),
            SizedBox(height: 20,),
            Text(_menu, style: TextStyle(fontSize: _height/50, fontFamily: 'Godo', color: Theme.of(context).backgroundColor == Colors.white? Colors.black : Colors.white),),
            Flexible(child: Container(),),
            Text('$_price ${TranslationManager.of(context).trans("menu_price")}', style: TextStyle(fontSize: _height/50, fontFamily: 'Godo', fontWeight: FontWeight.bold, color: Theme.of(context).backgroundColor == Colors.white ? Color.fromARGB(255, 20, 75, 170) : Colors.lightBlue),)
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
    double _width;
    double _height;

    _width= MediaQuery.of(context).size.width;
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
                Text('전화 걸기'),
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
                Text('전화 번호 미제공'),
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
                  style: TextStyle(fontSize: _height/40, fontFamily: 'Godo', color: Theme.of(context).backgroundColor == Colors.white? Colors.black : Colors.white),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(info.menu, style: TextStyle(fontSize: _height/50, fontFamily: 'Godo', color: Theme.of(context).backgroundColor == Colors.white? Colors.black : Colors.white), maxLines: 1, overflow: TextOverflow.ellipsis, softWrap: true,),
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