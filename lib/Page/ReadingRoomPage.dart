import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app_hyuabot_v2/Config/GlobalVars.dart';
import 'package:get/get.dart';

class ReadingRoomPage extends StatelessWidget{
  final int initialPage;
  ReadingRoomPage(this.initialPage);

  @override
  Widget build(BuildContext context) {
    final double _statusBarHeight = MediaQuery.of(context).padding.top;
    final List<String> _campusList = ["서울", "ERICA"];
    final TextStyle _theme1 = Theme.of(context).textTheme.bodyText1;
    final TextStyle _theme2 = Theme.of(context).textTheme.bodyText2;

    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: DefaultTabController(
          length: 2,
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
                  tabs: _campusList.map((e) => Text(e, style: TextStyle(fontFamily: "Godo", color: Theme.of(context).textTheme.bodyText1.color, fontSize: 16),)).toList()
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    Container(),
                    Container(),
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