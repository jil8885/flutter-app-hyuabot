import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app_hyuabot_v2/Config/GlobalVars.dart';
import 'package:flutter_app_hyuabot_v2/Config/Style.dart';
import 'package:flutter_app_hyuabot_v2/Model/Shuttle.dart';
import 'package:flutter_app_hyuabot_v2/UI/CustomCard.dart';
import 'package:get/get.dart';

import 'package:flutter_app_hyuabot_v2/Page/SettingPage.dart';

class HomePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{
  bool _isExpanded = false;
  Timer _shuttleTimer;

  void _expand() {
    setState(() {
      _isExpanded ? _isExpanded = false : _isExpanded = true;
    });
  }

  Widget _menuButton(double width, double height, String assetName, String menuName, Widget newPage, Color color){
    return Column(
      children: [
        GestureDetector(
          onTap: (){Get.to(newPage);},
          child: Container(child: Image.asset(assetName, width: width, height: height,), decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),),
        ),
        SizedBox(height: 5,),
        Flexible(child: Text(menuName, style: TextStyle(color: Theme.of(context).textTheme.bodyText1.color, fontSize: 13, fontFamily: 'Godo'),))
      ],
    );
  }

  Widget _homeShuttleItems(BuildContext context, String title, List<String> departureInfo, ShuttleStopDepartureInfo data) {
    return GestureDetector(
      onTap: () {
        // 셔틀 정보로 이동
      },
      child: CustomShuttleCard(
        title: title,
        timetable: departureInfo,
        data: data
      ),
    );
  }

  @override
  void initState() {
    _shuttleTimer = Timer.periodic(Duration(minutes: 1), (timer) {shuttleController.fetch();});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // 화면 너비, 크기 조정
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    Color _primaryColor = Theme.of(context).accentColor;

    // 메뉴 아이콘 너비, 높이
    double _itemWidth = _width / 6;
    double _itemHeight = _height / 12;

    Widget _menuWidget = Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: AnimatedCrossFade(
        crossFadeState: _isExpanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
        duration: kThemeAnimationDuration,
        firstChild: GridView.count(
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 4,
          shrinkWrap: true,
          children: [
            _menuButton(_itemWidth, _itemHeight, "assets/images/hanyang-shuttle.png", "셔틀버스", Container(), _primaryColor.withOpacity(0.3)),
            _menuButton(_itemWidth, _itemHeight, "assets/images/hanyang-bus.png", "노선버스", Container(), _primaryColor.withOpacity(0.3)),
            _menuButton(_itemWidth, _itemHeight, "assets/images/hanyang-metro.png", "지하철", Container(), _primaryColor.withOpacity(0.3)),
            _menuButton(_itemWidth, _itemHeight, "assets/images/hanyang-food.png", "학식", Container(), _primaryColor.withOpacity(0.3)),
            _menuButton(_itemWidth, _itemHeight, "assets/images/hanyang-reading-room.png", "열람실", Container(), _primaryColor.withOpacity(0.3)),
            _menuButton(_itemWidth, _itemHeight, "assets/images/hanyang-phone.png", "전화부", Container(), _primaryColor.withOpacity(0.3)),
            // _menuButton(_width / 12, _width / 12, null, "셔틀", Container()),
            // _menuButton(_width / 12, _width / 12, null, "셔틀", Container()),
          ],
        ),
        secondChild: GridView.count(
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 4,
          shrinkWrap: true,
          children: [
            _menuButton(_itemWidth, _itemHeight, "assets/images/hanyang-shuttle.png", "셔틀버스", Container(), _primaryColor.withOpacity(0.3)),
            _menuButton(_itemWidth, _itemHeight, "assets/images/hanyang-bus.png", "노선버스", Container(), _primaryColor.withOpacity(0.3)),
            _menuButton(_itemWidth, _itemHeight, "assets/images/hanyang-metro.png", "지하철", Container(), _primaryColor.withOpacity(0.3)),
            _menuButton(_itemWidth, _itemHeight, "assets/images/hanyang-food.png", "학식", Container(), _primaryColor.withOpacity(0.3)),
          ],
        ),
      ),
    );

    Widget _shuttleCardList = Container(
      height: _height / 4.5,
      width: _width,
      child: StreamBuilder<Map<String, ShuttleStopDepartureInfo>>(
        stream: shuttleController.allShuttleInfo,
        builder: (context, snapshot){
          if(snapshot.hasError || !snapshot.hasData){
            return Center(child: CircularProgressIndicator());
          } else {
            List<dynamic> residenceStn = snapshot.data["Residence"].shuttleListStation..addAll(snapshot.data["Residence"].shuttleListCycle)..sort();
            List<dynamic> residenceTerminal = snapshot.data["Residence"].shuttleListTerminal..addAll(snapshot.data["Residence"].shuttleListCycle)..sort();
            List<dynamic> schoolStn = snapshot.data["Shuttlecock_O"].shuttleListStation..addAll(snapshot.data["Shuttlecock_O"].shuttleListCycle)..sort();
            List<dynamic> schoolTerminal = snapshot.data["Shuttlecock_O"].shuttleListTerminal..addAll(snapshot.data["Shuttlecock_O"].shuttleListCycle)..sort();
            List<dynamic> station = snapshot.data["Subway"].shuttleListStation..addAll(snapshot.data["Subway"].shuttleListCycle)..sort();
            List<dynamic> terminal = snapshot.data["YesulIn"].shuttleListTerminal..addAll(snapshot.data["YesulIn"].shuttleListCycle)..sort();
            List<dynamic> schoolResidence = snapshot.data["Shuttlecock_I"].shuttleListStation..addAll(snapshot.data["Shuttlecock_I"].shuttleListTerminal)..addAll(snapshot.data["Shuttlecock_I"].shuttleListCycle)..sort();
            List<Set<dynamic>> allShuttleList = [residenceStn.toSet(), residenceTerminal.toSet(), schoolStn.toSet(), schoolTerminal.toSet(), station.toSet(), terminal.toSet(), schoolResidence.toSet()];
            List<String> stopList = ["기숙사 → 한대앞", "기숙사 → 예술인", "셔틀콕 → 한대앞", "셔틀콕 → 예술인", "한대앞", "예술인", "기숙사 건너편"];
            List<ShuttleStopDepartureInfo> data = [snapshot.data["Residence"], snapshot.data["Residence"], snapshot.data["Shuttlecock_O"], snapshot.data["Shuttlecock_O"], snapshot.data["Subway"], snapshot.data["YesulIn"], snapshot.data["Shuttlecock_I"]];
            return ListView.builder(
              padding: EdgeInsets.all(5),
              shrinkWrap: true,
              itemCount: 7,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index){
                return _homeShuttleItems(context, stopList[index], allShuttleList[index].map((e) => e.toString()).toList(), data[index]);
              },
            );
          }
        },
      ),
    );

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        elevation: 3,
        onPressed: () => Get.to(SettingPage()),
        label: Text("설정", textAlign: TextAlign.center, style: TextStyle(color:Colors.white, fontFamily: 'Godo'),),
        icon: Icon(Icons.settings),
        backgroundColor: _primaryColor,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: MainAppBar(),
      body: Container(
        height: _height,
        width: _width,
        child: Column(
          children: [
            // clipShape(),
            Container(
              margin: EdgeInsets.only(left: 30, right: 30, top: 30, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('메뉴', style: TextStyle(fontSize: 16, fontFamily: 'Godo')),
                  GestureDetector(
                      onTap: _expand,
                      child: Text(_isExpanded ? "줄이기" : "전체 보기", style: TextStyle(color: _primaryColor, fontFamily: 'Godo'),
                      )),
                ],
              ),
            ),
            _menuWidget,
            Divider(),
            Container(
              margin: EdgeInsets.only(left: 30, right: 30, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("셔틀", style: TextStyle(fontSize: 16, fontFamily: 'Godo')),
                  GestureDetector(
                      onTap: (){Get.to(Container());},
                      child: Text("전체 정류장 정보 보기", style: TextStyle(color: _primaryColor, fontFamily: 'Godo'),
                      )),
                ],
              ),
            ),
            _shuttleCardList,
          ],
        ),
      ),
    );
  }

}