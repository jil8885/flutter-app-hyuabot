import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app_hyuabot_v2/Bloc/FoodController.dart';
import 'package:flutter_app_hyuabot_v2/Bloc/ShuttleController.dart';
import 'package:flutter_app_hyuabot_v2/Config/AdManager.dart';
import 'package:flutter_app_hyuabot_v2/Config/GlobalVars.dart';
import 'package:flutter_app_hyuabot_v2/Config/Localization.dart';
import 'package:flutter_app_hyuabot_v2/Config/Style.dart';
import 'package:flutter_app_hyuabot_v2/Model/FoodMenu.dart';
import 'package:flutter_app_hyuabot_v2/Model/Shuttle.dart';
import 'package:flutter_app_hyuabot_v2/Page/BusPage.dart';
import 'package:flutter_app_hyuabot_v2/Page/MapPage.dart';
import 'package:flutter_app_hyuabot_v2/Page/MetroPage.dart';
import 'package:flutter_app_hyuabot_v2/Page/PhoneSearchPage.dart';
import 'package:flutter_app_hyuabot_v2/Page/ReadingRoomPage.dart';
import 'package:flutter_app_hyuabot_v2/Page/SettingPage.dart';
import 'package:flutter_app_hyuabot_v2/Page/FoodPage.dart';
import 'package:flutter_app_hyuabot_v2/Page/ShuttlePage.dart';
import 'package:flutter_app_hyuabot_v2/UI/CustomCard.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_options.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';


class HomePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver{
  final FetchAllShuttleController _shuttleController = FetchAllShuttleController();
  final FetchFoodInfoController _foodInfoController = FetchFoodInfoController();
  final _ExpandMenuController _menuController = _ExpandMenuController();

  Timer _foodTimer;
  Timer _shuttleTimer;

  _HomePageState(){
    adController.setTestDeviceIds(["546EDDAE2CC55DE1869DB0E70BF1A549"]);
    adController.reloadAd(forceRefresh: true, numberAds: 5);
    adController.setAdUnitID(AdManager.bannerAdUnitId);
  }

  @override
  void initState() {
    super.initState();
    _foodTimer = Timer.periodic(Duration(seconds: 10), (timer) {_foodInfoController.fetchFood();});
    _shuttleTimer = Timer.periodic(Duration(minutes: 1), (timer) {_shuttleController.fetch();});
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(state == AppLifecycleState.resumed){
      if(!_foodTimer.isActive){_foodTimer = Timer.periodic(Duration(seconds: 10), (timer) {_foodInfoController.fetchFood();});}
      if(!_shuttleTimer.isActive){_shuttleTimer = Timer.periodic(Duration(minutes: 1), (timer) {_shuttleController.fetch();});}
    }else if(state == AppLifecycleState.inactive){
      if(_foodTimer.isActive){_foodTimer.cancel();}
      if(_shuttleTimer.isActive){_shuttleTimer.cancel();}
    }else if(state == AppLifecycleState.paused){
      if(_foodTimer.isActive){_foodTimer.cancel();}
      if(_shuttleTimer.isActive){_shuttleTimer.cancel();}
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _shuttleController.dispose();
    _foodInfoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 화면 너비, 크기 조정
    final double _width = MediaQuery.of(context).size.width;
    final double _height = MediaQuery.of(context).size.height;
    final Color _primaryColor = Theme.of(context).accentColor;

    // 메뉴 아이콘 너비, 높이
    final double _itemWidth = _width / 10;
    final double _itemHeight = _width / 10;

    // 식당 이름들
    final _cafeteriaNames = [
      TranslationManager.of(context).trans("student_cafeteria"),
      TranslationManager.of(context).trans("teacher_cafeteria"),
      TranslationManager.of(context).trans("food_court"),
      TranslationManager.of(context).trans("changbo_cafeteria"),
      TranslationManager.of(context).trans("dorm_cafeteria"),
    ];
    final _cafeteriaKeys = [
      "student_erica",
      "teacher_erica",
      "food_court_erica",
      "changbo_erica",
      "dorm_erica"
    ];

    final Widget _menuWidget = StreamBuilder<bool>(
        stream: _menuController.isExpanded,
        builder: (context, snapshot) {
          bool _isExpanded;
          if(!snapshot.hasData || snapshot.hasError){
            _isExpanded=false;
          }else{
            _isExpanded = snapshot.data;
          }
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 15),
            child: AnimatedCrossFade(
              crossFadeState:
              _isExpanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
              duration: kThemeAnimationDuration,
              firstChild: GridView.count(
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 4,
                shrinkWrap: true,
                children: [
                  _menuButton(context, _itemWidth, _itemHeight, "assets/images/hanyang-shuttle.png", TranslationManager.of(context).trans("shuttle_btn"), ShuttlePage(), Theme.of(context).backgroundColor == Colors.white ? _primaryColor.withOpacity(0.3) : Colors.white30),
                  _menuButton(context, _itemWidth, _itemHeight, "assets/images/hanyang-bus.png", TranslationManager.of(context).trans("bus_btn"), BusPage(), Theme.of(context).backgroundColor == Colors.white ? _primaryColor.withOpacity(0.3) : Colors.white30),
                  _menuButton(context, _itemWidth, _itemHeight, "assets/images/hanyang-metro.png", TranslationManager.of(context).trans("metro_btn"), MetroPage(), Theme.of(context).backgroundColor == Colors.white ? _primaryColor.withOpacity(0.3) : Colors.white30),
                  _menuButton(context, _itemWidth, _itemHeight, "assets/images/hanyang-food.png", TranslationManager.of(context).trans("food_btn"), FoodPage(), Theme.of(context).backgroundColor == Colors.white ? _primaryColor.withOpacity(0.3) : Colors.white30),
                  _menuButton(context, _itemWidth, _itemHeight, "assets/images/hanyang-reading-room.png", TranslationManager.of(context).trans("reading_room_btn"), ReadingRoomPage(), Theme.of(context).backgroundColor == Colors.white ? _primaryColor.withOpacity(0.3) : Colors.white30),
                  _menuButton(context, _itemWidth, _itemHeight, "assets/images/hanyang-phone.png", TranslationManager.of(context).trans("contact_btn"), PhoneSearchPage(), Theme.of(context).backgroundColor == Colors.white ? _primaryColor.withOpacity(0.3) : Colors.white30),
                  _menuButton(context, _itemWidth, _itemHeight, "assets/images/hanyang-map.png", TranslationManager.of(context).trans("map_btn"), MapPage(), Theme.of(context).backgroundColor == Colors.white ? _primaryColor.withOpacity(0.3) : Colors.white30),
                ],
              ),
              secondChild: GridView.count(
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 4,
                shrinkWrap: true,
                children: [
                  _menuButton(context, _itemWidth, _itemHeight, "assets/images/hanyang-shuttle.png", TranslationManager.of(context).trans("shuttle_btn"), ShuttlePage(), Theme.of(context).backgroundColor == Colors.white ? _primaryColor.withOpacity(0.3) : Colors.white30),
                  _menuButton(context, _itemWidth, _itemHeight, "assets/images/hanyang-bus.png", TranslationManager.of(context).trans("bus_btn"), BusPage(), Theme.of(context).backgroundColor == Colors.white ? _primaryColor.withOpacity(0.3) : Colors.white30),
                  _menuButton(context, _itemWidth, _itemHeight, "assets/images/hanyang-metro.png", TranslationManager.of(context).trans("metro_btn"), MetroPage(), Theme.of(context).backgroundColor == Colors.white ? _primaryColor.withOpacity(0.3) : Colors.white30),
                  _menuButton(context, _itemWidth, _itemHeight, "assets/images/hanyang-food.png", TranslationManager.of(context).trans("food_btn"), FoodPage(), Theme.of(context).backgroundColor == Colors.white ? _primaryColor.withOpacity(0.3) : Colors.white30)
                ],
              ),
            ),
          );
        }
    );

    final Widget _shuttleCardList = Container(
      height: _height / 4,
      width: _width,
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: StreamBuilder<Map<String, ShuttleStopDepartureInfo>>(
        stream: _shuttleController.allShuttleInfo,
        builder: (context, snapshot) {
          if (snapshot.hasError || !snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            List<dynamic> residenceStn =
            List.from(snapshot.data["Residence"].shuttleListStation)
              ..addAll(snapshot.data["Residence"].shuttleListCycle)
              ..sort();
            List<dynamic> residenceTerminal =
            List.from(snapshot.data["Residence"].shuttleListTerminal)
              ..addAll(snapshot.data["Residence"].shuttleListCycle)
              ..sort();
            List<dynamic> schoolStn =
            List.from(snapshot.data["Shuttlecock_O"].shuttleListStation)
              ..addAll(snapshot.data["Shuttlecock_O"].shuttleListCycle)
              ..sort();
            List<dynamic> schoolTerminal =
            List.from(snapshot.data["Shuttlecock_O"].shuttleListTerminal)
              ..addAll(snapshot.data["Shuttlecock_O"].shuttleListCycle)
              ..sort();
            List<dynamic> station =
            List.from(snapshot.data["Subway"].shuttleListStation)
              ..addAll(snapshot.data["Subway"].shuttleListCycle)
              ..sort();
            List<dynamic> terminal =
            List.from(snapshot.data["YesulIn"].shuttleListTerminal)
              ..addAll(snapshot.data["YesulIn"].shuttleListCycle)
              ..sort();
            List<dynamic> schoolResidence =
            List.from(snapshot.data["Shuttlecock_I"].shuttleListStation)
              ..addAll(snapshot.data["Shuttlecock_I"].shuttleListTerminal)
              ..addAll(snapshot.data["Shuttlecock_I"].shuttleListCycle)
              ..sort();
            List<Set<dynamic>> allShuttleList = [
              residenceStn.toSet(),
              residenceTerminal.toSet(),
              schoolStn.toSet(),
              schoolTerminal.toSet(),
              station.toSet(),
              terminal.toSet(),
              schoolResidence.toSet()
            ];
            List<String> stopList = [
              "${TranslationManager.of(context).trans("bus_stop_dorm")} → ${TranslationManager.of(context).trans("bus_stop_station")}",
              "${TranslationManager.of(context).trans("bus_stop_dorm")} → ${TranslationManager.of(context).trans("bus_stop_terminal")}",
              "${TranslationManager.of(context).trans("bus_stop_school")} → ${TranslationManager.of(context).trans("bus_stop_station")}",
              "${TranslationManager.of(context).trans("bus_stop_school")} → ${TranslationManager.of(context).trans("bus_stop_terminal")}",
              TranslationManager.of(context).trans("bus_stop_station"),
              TranslationManager.of(context).trans("bus_stop_terminal"),
              TranslationManager.of(context).trans("bus_stop_school_opposite")
            ];
            List<ShuttleStopDepartureInfo> data = [
              snapshot.data["Residence"],
              snapshot.data["Residence"],
              snapshot.data["Shuttlecock_O"],
              snapshot.data["Shuttlecock_O"],
              snapshot.data["Subway"],
              snapshot.data["YesulIn"],
              snapshot.data["Shuttlecock_I"]
            ];
            return ListView.builder(
              padding: EdgeInsets.all(5),
              shrinkWrap: true,
              itemCount: 7,
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return _homeShuttleItems(
                    context,
                    stopList[index],
                    allShuttleList[index].map((e) => e.toString()).toList(),
                    data[index]);
              },
            );
          }
        },
      ),
    );

    final Widget _homeFoodMenu = StreamBuilder<Object>(
        stream: _foodInfoController.allFoodInfo,
        builder: (context, snapshot) {
          if (snapshot.hasError || !snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          // food info
          Map<String, Map<String, List<FoodMenu>>> allMenus = snapshot.data;
          _foodTimer.cancel();
          return Container(
            height: _height / 4,
            width: _width,
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: ListView.builder(
              padding: EdgeInsets.all(5),
              shrinkWrap: true,
              itemCount: 5,
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                DateTime _now = DateTime.now();
                if (_now.hour < 11 &&
                    allMenus[_cafeteriaKeys[index]]['breakfast'].isNotEmpty) {
                  return _foodItems(
                      context,
                      _cafeteriaNames[index],
                      TranslationManager.of(context).trans("breakfast"),
                      index,
                      allMenus[_cafeteriaKeys[index]]['breakfast']
                          .elementAt(0));
                } else if (_now.hour > 15 &&
                    allMenus[_cafeteriaKeys[index]]['dinner'].isNotEmpty) {
                  return _foodItems(
                      context,
                      _cafeteriaNames[index],
                      TranslationManager.of(context).trans("dinner"),
                      index,
                      allMenus[_cafeteriaKeys[index]]['dinner'].elementAt(0));
                } else if (allMenus[_cafeteriaKeys[index]]['lunch']
                    .isNotEmpty) {
                  return _foodItems(
                      context,
                      _cafeteriaNames[index],
                      TranslationManager.of(context).trans("lunch"),
                      index,
                      allMenus[_cafeteriaKeys[index]]['lunch'].elementAt(0));
                }
                return _foodItems(context, _cafeteriaNames[index],
                    TranslationManager.of(context).trans("lunch"), index, null);
              },
            ),
          );
        });

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        elevation: 3,
        onPressed: () => Get.to(SettingPage()),
        label: Text(
          TranslationManager.of(context).trans("setting_title"),
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
        ),
        icon: Icon(Icons.settings, color: Colors.white),
        backgroundColor: _primaryColor,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: MainAppBar(),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: BouncingScrollPhysics(),
        child: Container(
          width: _width,
          color: Theme.of(context).backgroundColor,
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
                  error: Center(
                      child: Text(
                        TranslationManager.of(context).trans("plz_enable_ad"),
                        style: TextStyle(
                            color: Theme.of(context).textTheme.bodyText1.color,
                            fontSize: 14),
                        textAlign: TextAlign.center,
                      )),
                  options: NativeAdmobOptions(
                    adLabelTextStyle: NativeTextStyle(
                      color: Theme.of(context).textTheme.bodyText1.color,
                    ),
                    bodyTextStyle: NativeTextStyle(
                        color: Theme.of(context).textTheme.bodyText1.color),
                    headlineTextStyle: NativeTextStyle(
                        color: Theme.of(context).textTheme.bodyText1.color),
                    advertiserTextStyle: NativeTextStyle(
                        color: Theme.of(context).textTheme.bodyText1.color),
                  ),
                ),
              ),
              Container(
                margin:
                EdgeInsets.only(left: 30, right: 30, top: 30, bottom: 20),
                child: GestureDetector(
                  onTap: _expand,
                  child: Row(
                    children: <Widget>[
                      Text(TranslationManager.of(context).trans("menu_list"),
                          style: TextStyle(
                              fontSize: 18,
                              color:
                              Theme.of(context).textTheme.bodyText1.color)),
                      Expanded(child: Container()),
                      StreamBuilder<bool>(
                          stream: _menuController.isExpanded,
                          builder: (context, snapshot) {
                            bool _isExpanded;
                            if(!snapshot.hasData || snapshot.hasError){
                              _isExpanded=false;
                            }else{
                              _isExpanded = snapshot.data;
                            }
                            return Text(
                              _isExpanded ? TranslationManager.of(context).trans("shrink_menu") : TranslationManager.of(context).trans("expand_menu"),
                              style: TextStyle(color: Theme.of(context).backgroundColor == Colors.white ? _primaryColor : Colors.white, fontFamily: 'Godo', fontSize: 18),
                            );
                          }
                      ),
                    ],
                  ),
                ),
              ),
              _menuWidget,
              Divider(),
              Container(
                margin: EdgeInsets.only(left: 30, right: 30, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(TranslationManager.of(context).trans("shuttle_list"),
                        style: TextStyle(
                            fontSize: 18,
                            color:
                            Theme.of(context).textTheme.bodyText1.color)),
                    GestureDetector(
                        onTap: () {
                          Get.to(ShuttlePage());
                        },
                        child: Text(
                          TranslationManager.of(context)
                              .trans("show_all_shuttle"),
                          style: TextStyle(
                              color: Theme.of(context).backgroundColor ==
                                  Colors.white
                                  ? _primaryColor
                                  : Colors.white,
                              fontFamily: 'Godo',
                              fontSize: 18,
                          ),
                        )),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              _shuttleCardList,
              Divider(),
              Container(
                margin: EdgeInsets.only(left: 30, right: 30, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(TranslationManager.of(context).trans("food_now"),
                        style: TextStyle(
                            fontSize: 18,
                            color:
                            Theme.of(context).textTheme.bodyText1.color)),
                    GestureDetector(
                        onTap: () {
                          Get.to(FoodPage());
                        },
                        child: Text(
                          TranslationManager.of(context).trans("show_all_food"),
                          style: TextStyle(
                              color: Theme.of(context).backgroundColor ==
                                  Colors.white
                                  ? _primaryColor
                                  : Colors.white,
                              fontFamily: 'Godo',
                              fontSize: 18,
                          ),
                        )),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              _homeFoodMenu,
              SizedBox(
                height: 60,
              )
            ],
          ),
        ),
      ),
    );
  }

  void _expand() {
    _menuController.change();
  }

  Widget _menuButton(BuildContext context, double width, double height, String assetName, String menuName, Widget newPage, Color color) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {Get.to(newPage, duration: kThemeAnimationDuration);},
          child: Container(
            child: Image.asset(
              assetName,
              width: width,
              height: height,
            ),
            decoration: BoxDecoration(
                color: color, borderRadius: BorderRadius.circular(10)),
            padding: EdgeInsets.all(10),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          menuName,
          style: TextStyle(
          color: Theme.of(context).textTheme.bodyText1.color, fontSize: 13),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 5,
        ),
      ],
    );
  }

  Widget _homeShuttleItems(BuildContext context, String title,
    List<String> departureInfo, ShuttleStopDepartureInfo data) {
    return GestureDetector(
      onTap: () {
        Get.to(ShuttlePage());
      },
      child:
          CustomShuttleCard(title: title, timetable: departureInfo, data: data),
    );
  }

  Widget _foodItems(BuildContext context, String title, String time, int index,
      FoodMenu data) {
    return GestureDetector(
      onTap: () {
        Get.to(FoodPage());
      },
      child: CustomFoodCard(title: title, time: time, data: data),
    );
  }

}

class _ExpandMenuController {
  final _expandableSubject = BehaviorSubject<bool>();

  _ExpandMenuController(){_expandableSubject.add(true);}
  void change(){
    _expandableSubject.add(!_expandableSubject.value);
  }

  Stream<bool> get isExpanded => _expandableSubject.stream;
}