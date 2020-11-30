import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app_hyuabot_v2/Config/AdManager.dart';
import 'package:flutter_app_hyuabot_v2/Config/GlobalVars.dart';
import 'package:flutter_app_hyuabot_v2/Config/Style.dart';
import 'package:flutter_app_hyuabot_v2/Model/FoodMenu.dart';
import 'package:flutter_app_hyuabot_v2/Model/Shuttle.dart';
import 'package:flutter_app_hyuabot_v2/Page/ShuttlePage.dart';
import 'package:flutter_app_hyuabot_v2/UI/CustomCard.dart';
import 'package:flutter_app_hyuabot_v2/Config/Networking.dart' as conf;
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_options.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;


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

  void _fetchFood() async {
    final url = Uri.encodeFull(conf.getAPIServer() + "/app/food");
    http.Response response = await http.get(url);
    Map<String, dynamic> responseJson = jsonDecode(utf8.decode(response.bodyBytes));
    for(String name in responseJson.keys){
      if(name.contains("erica")){
        allMenus[name] = {"breakfast": [], "lunch": [], "dinner": []};
        for(String time in responseJson[name].keys){
          switch(time){
            case "조식":
              allMenus[name]['breakfast'] = (responseJson[name][time] as List).map((e) => FoodMenu.fromJson(e)).toList();
              break;
            case "중식":
              allMenus[name]['lunch'] = (responseJson[name][time] as List).map((e) => FoodMenu.fromJson(e)).toList();
              break;
            case "석식":
              allMenus[name]['dinner'] = (responseJson[name][time] as List).map((e) => FoodMenu.fromJson(e)).toList();
              break;
          }
        }
      }
    }
  }

  Widget _menuButton(double width, double height, String assetName, String menuName, Widget newPage, Color color){
    return Column(
      children: [
        GestureDetector(
          onTap: (){Get.to(newPage);},
          child: Container(child: Image.asset(assetName, width: width, height: height,), decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)), padding: EdgeInsets.all(10),),
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

  Widget _foodItems(BuildContext context, String title, String time, FoodMenu data) {
    return GestureDetector(
      onTap: () {
        // 셔틀 정보로 이동
      },
      child: CustomFoodCard(
          title: title,
          time: time,
          data: data
      ),
    );
  }

  @override
  void initState() {
    _shuttleTimer = Timer.periodic(Duration(minutes: 1), (timer) {shuttleController.fetch();});
    adController.setTestDeviceIds(["8F53CD4DC1C32BBF724766A8608006FF"]);
    adController.reloadAd(forceRefresh: true, numberAds: 1);
    adController.setAdUnitID(AdManager.bannerAdUnitId);
    _fetchFood();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // 화면 너비, 크기 조정
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    Color _primaryColor = Theme.of(context).accentColor;

    // 메뉴 아이콘 너비, 높이
    double _itemWidth = _width / 10;
    double _itemHeight = _width / 10;

    // 식당 이름들
    final _cafeteriaNames = ["학생식당", "교직원식당", "푸드코트", "창업보육센터", "창의인재원식당"];
    final _cafeteriaKeys = ["student_erica", "teacher_erica", "foodcoart_erica", "changbo_erica", "dorm_erica"];

    Widget _menuWidget = Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      child: AnimatedCrossFade(
        crossFadeState: _isExpanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
        duration: kThemeAnimationDuration,
        firstChild: GridView.count(
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 4,
          shrinkWrap: true,
          children: [
            _menuButton(_itemWidth, _itemHeight, "assets/images/hanyang-shuttle.png", "셔틀버스", ShuttlePage(), Theme.of(context).backgroundColor == Colors.white ? _primaryColor.withOpacity(0.3) : Colors.white30),
            _menuButton(_itemWidth, _itemHeight, "assets/images/hanyang-bus.png", "노선버스", Container(), Theme.of(context).backgroundColor == Colors.white ? _primaryColor.withOpacity(0.3) : Colors.white30),
            _menuButton(_itemWidth, _itemHeight, "assets/images/hanyang-metro.png", "지하철", Container(), Theme.of(context).backgroundColor == Colors.white ? _primaryColor.withOpacity(0.3) : Colors.white30),
            _menuButton(_itemWidth, _itemHeight, "assets/images/hanyang-food.png", "학식", Container(), Theme.of(context).backgroundColor == Colors.white ? _primaryColor.withOpacity(0.3) : Colors.white30),
            _menuButton(_itemWidth, _itemHeight, "assets/images/hanyang-reading-room.png", "열람실", Container(), Theme.of(context).backgroundColor == Colors.white ? _primaryColor.withOpacity(0.3) : Colors.white30),
            _menuButton(_itemWidth, _itemHeight, "assets/images/hanyang-phone.png", "전화부", Container(), Theme.of(context).backgroundColor == Colors.white ? _primaryColor.withOpacity(0.3) : Colors.white30),
            // _menuButton(_width / 12, _width / 12, null, "셔틀", Container()),
            // _menuButton(_width / 12, _width / 12, null, "셔틀", Container()),
          ],
        ),
        secondChild: GridView.count(
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 4,
          shrinkWrap: true,
          children: [
            _menuButton(_itemWidth, _itemHeight, "assets/images/hanyang-shuttle.png", "셔틀버스", ShuttlePage(), Theme.of(context).backgroundColor == Colors.white ? _primaryColor.withOpacity(0.3) : Colors.white30),
            _menuButton(_itemWidth, _itemHeight, "assets/images/hanyang-bus.png", "노선버스", Container(), Theme.of(context).backgroundColor == Colors.white ? _primaryColor.withOpacity(0.3) : Colors.white30),
            _menuButton(_itemWidth, _itemHeight, "assets/images/hanyang-metro.png", "지하철", Container(), Theme.of(context).backgroundColor == Colors.white ? _primaryColor.withOpacity(0.3) : Colors.white30),
            _menuButton(_itemWidth, _itemHeight, "assets/images/hanyang-food.png", "학식", Container(), Theme.of(context).backgroundColor == Colors.white ? _primaryColor.withOpacity(0.3) : Colors.white30),
          ],
        ),
      ),
    );

    Widget _shuttleCardList = Container(
      height: _height / 4.5,
      width: _width,
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: StreamBuilder<Map<String, ShuttleStopDepartureInfo>>(
        stream: shuttleController.allShuttleInfo,
        builder: (context, snapshot){
          if(snapshot.hasError || !snapshot.hasData){
            return Center(child: CircularProgressIndicator());
          } else {
            List<dynamic> residenceStn = List.from(snapshot.data["Residence"].shuttleListStation)..addAll(snapshot.data["Residence"].shuttleListCycle)..sort();
            List<dynamic> residenceTerminal = List.from(snapshot.data["Residence"].shuttleListTerminal)..addAll(snapshot.data["Residence"].shuttleListCycle)..sort();
            List<dynamic> schoolStn = List.from(snapshot.data["Shuttlecock_O"].shuttleListStation)..addAll(snapshot.data["Shuttlecock_O"].shuttleListCycle)..sort();
            List<dynamic> schoolTerminal = List.from(snapshot.data["Shuttlecock_O"].shuttleListTerminal)..addAll(snapshot.data["Shuttlecock_O"].shuttleListCycle)..sort();
            List<dynamic> station = List.from(snapshot.data["Subway"].shuttleListStation)..addAll(snapshot.data["Subway"].shuttleListCycle)..sort();
            List<dynamic> terminal = List.from(snapshot.data["YesulIn"].shuttleListTerminal)..addAll(snapshot.data["YesulIn"].shuttleListCycle)..sort();
            List<dynamic> schoolResidence = List.from(snapshot.data["Shuttlecock_I"].shuttleListStation)..addAll(snapshot.data["Shuttlecock_I"].shuttleListTerminal)..addAll(snapshot.data["Shuttlecock_I"].shuttleListCycle)..sort();
            List<Set<dynamic>> allShuttleList = [residenceStn.toSet(), residenceTerminal.toSet(), schoolStn.toSet(), schoolTerminal.toSet(), station.toSet(), terminal.toSet(), schoolResidence.toSet()];
            List<String> stopList = ["기숙사 → 한대앞", "기숙사 → 예술인", "셔틀콕 → 한대앞", "셔틀콕 → 예술인", "한대앞", "예술인", "셔틀콕 건너편"];
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

    Widget _homeFoodMenu = Container(
      height: _height / 4.5,
      width: _width,
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: ListView.builder(
        padding: EdgeInsets.all(5),
        shrinkWrap: true,
        itemCount: 5,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index){
          DateTime _now = DateTime.now();
          if(_now.hour < 11 && allMenus[_cafeteriaKeys[index]]['breakfast'].isNotEmpty){
            return _foodItems(context, _cafeteriaNames[index], "조식", allMenus[_cafeteriaKeys[index]]['breakfast'].elementAt(0));
          } else if (_now.hour > 15 && allMenus[_cafeteriaKeys[index]]['dinner'].isNotEmpty){
            return _foodItems(context, _cafeteriaNames[index], "석식", allMenus[_cafeteriaKeys[index]]['dinner'].elementAt(0));
          } else if (allMenus[_cafeteriaKeys[index]]['lunch'].isNotEmpty){
            return _foodItems(context, _cafeteriaNames[index], "중식", allMenus[_cafeteriaKeys[index]]['lunch'].elementAt(0));
          }
          return _foodItems(context, _cafeteriaNames[index], "중식", null);
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
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          width: _width,
          child: Column(
            children: [
              Container(
                height: 90,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: NativeAdmob(
                  adUnitID: AdManager.bannerAdUnitId,
                  numberAds: 1,
                  controller: adController,
                  type: NativeAdmobType.banner,
                  error: Center(child: Text("광고 불러오기 실패", style: TextStyle(color: Theme.of(context).textTheme.bodyText1.color, fontSize: 14), textAlign: TextAlign.center,)),
                  options: NativeAdmobOptions(
                    adLabelTextStyle: NativeTextStyle(color: Theme.of(context).textTheme.bodyText1.color,),
                    bodyTextStyle: NativeTextStyle(color: Theme.of(context).textTheme.bodyText1.color),
                    headlineTextStyle: NativeTextStyle(color: Theme.of(context).textTheme.bodyText1.color),
                    advertiserTextStyle: NativeTextStyle(color: Theme.of(context).textTheme.bodyText1.color),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 30, right: 30, top: 30, bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('메뉴', style: TextStyle(fontSize: 16, fontFamily: 'Godo', color:Theme.of(context).textTheme.bodyText1.color)),
                    GestureDetector(
                        onTap: _expand,
                        child: Text(_isExpanded ? "줄이기" : "전체 보기", style: TextStyle(color:Theme.of(context).backgroundColor == Colors.white ? _primaryColor : Colors.white, fontFamily: 'Godo'),
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
                    Text("셔틀", style: TextStyle(fontSize: 16, fontFamily: 'Godo', color:Theme.of(context).textTheme.bodyText1.color)),
                    GestureDetector(
                        onTap: (){
                          _shuttleTimer.cancel();
                          shuttleController.fetch();
                          Get.to(ShuttlePage());
                          },
                        child: Text("전체 정류장 정보 보기", style: TextStyle(color:Theme.of(context).backgroundColor == Colors.white ? _primaryColor : Colors.white, fontFamily: 'Godo'),
                        )),
                  ],
                ),
              ),
              SizedBox(height: 10,),
              _shuttleCardList,
              Divider(),
              Container(
                margin: EdgeInsets.only(left: 30, right: 30, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("현재의 학식", style: TextStyle(fontSize: 16, fontFamily: 'Godo', color:Theme.of(context).textTheme.bodyText1.color)),
                    GestureDetector(
                        onTap: (){

                        },
                        child: Text("전체 학식 메뉴 보기", style: TextStyle(color:Theme.of(context).backgroundColor == Colors.white ? _primaryColor : Colors.white, fontFamily: 'Godo'),
                        )
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10,),
              _homeFoodMenu,
              SizedBox(height: 60,)
            ],
          ),
        ),
      ),
    );
  }

}