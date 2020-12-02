import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app_hyuabot_v2/Config/GlobalVars.dart';
import 'package:get/get.dart';

class ShuttlePage extends StatelessWidget{
  final int initialPage;
  ShuttlePage(this.initialPage);

  Widget bothDirectionStop(BuildContext context, String stopName, List<String> timeList){
    return Container(
      padding: EdgeInsets.all(15),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(30), bottomRight: Radius.circular(30))),
            color: Theme.of(context).backgroundColor,
            elevation: 1,
            child: Container(
              height: 60,
              margin: EdgeInsets.symmetric(vertical: 15),
              width: MediaQuery.of(context).size.width - 30,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(stopName, style: TextStyle(color: Theme.of(context).backgroundColor == Colors.white? Colors.black : Colors.white, fontSize: 25),),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("평일 ${timeList[0]}", style: TextStyle(color: Theme.of(context).backgroundColor == Colors.white? Colors.black : Colors.white),),
                      Text("주말 ${timeList[1]}", style: TextStyle(color: Theme.of(context).backgroundColor == Colors.white? Colors.black : Colors.white),),
                    ],
                  )
                ],
              ),
            ),
          ),
          Divider(),
          Container(
            margin: EdgeInsets.only(left: 15, right: 15, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("한대앞 방면", style: TextStyle(fontSize: 16, fontFamily: 'Godo', color:Theme.of(context).textTheme.bodyText1.color)),
              ],
            ),
          ),
          SizedBox(height: 10,),
        ],
      ),
    );
  }

  Widget oneDirectionStop(BuildContext context, String stopName, List<String> timeList){
    return Container(
      padding: EdgeInsets.all(15),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(30), bottomRight: Radius.circular(30))),
            color: Theme.of(context).backgroundColor,
            elevation: 1,
            child: Container(
              height: 60,
              margin: EdgeInsets.symmetric(vertical: 15),
              width: MediaQuery.of(context).size.width - 30,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(stopName, style: TextStyle(color: Theme.of(context).backgroundColor == Colors.white? Colors.black : Colors.white, fontSize: 25),),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("평일 ${timeList[0]}", style: TextStyle(color: Theme.of(context).backgroundColor == Colors.white? Colors.black : Colors.white),),
                      Text("주말 ${timeList[1]}", style: TextStyle(color: Theme.of(context).backgroundColor == Colors.white? Colors.black : Colors.white),),
                    ],
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
  Widget build(BuildContext context) {
    final List<String> _busStopList = ["기숙사", "셔틀콕", "한대앞", "예술인", "셔틀콕 건너편"];

    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: DefaultTabController(
            length: 5,
            initialIndex: initialPage,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [IconButton(icon: Icon(Icons.arrow_back_rounded, color: Theme.of(context).textTheme.bodyText1.color,), onPressed: (){Get.back();},)],
                ),
                TabBar(
                  isScrollable: true,
                  labelPadding: EdgeInsets.only(left: 25, right: 25, top: 30, bottom: 10),
                  indicator: UnderlineTabIndicator(borderSide: BorderSide(color: Theme.of(context).accentColor, width: 2), insets: EdgeInsets.symmetric(horizontal: 10)),
                  tabs: _busStopList.map((e) => Text(e, style: TextStyle(fontFamily: "Godo", color: Theme.of(context).textTheme.bodyText1.color, fontSize: 16),)).toList()
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      bothDirectionStop(context, "기숙사", ["07:45/21:45", "08:45/21:45"]),
                      bothDirectionStop(context, "셔틀콕", ["07:50/21:50", "08:50/21:50"]),
                      oneDirectionStop(context, "한대앞", ["08:00/22:00", "09:00/22:00"]),
                      oneDirectionStop(context, "예술인", ["08:05/22:05", "09:05/22:05"]),
                      oneDirectionStop(context, "셔틀콕 건너편", ["08:15/22:15", "09:15/22:15"]),
                    ],
                  ),
                )
              ],
            ),
        ),
      ),
    );
  }
}