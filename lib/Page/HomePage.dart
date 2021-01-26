import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_options.dart';
import 'package:get/get.dart';

import 'package:flutter_app_hyuabot_v2/Bloc/FoodController.dart';
import 'package:flutter_app_hyuabot_v2/Bloc/ShuttleController.dart';
import 'package:flutter_app_hyuabot_v2/Config/AdManager.dart';
import 'package:flutter_app_hyuabot_v2/Config/GlobalVars.dart';
import 'package:flutter_app_hyuabot_v2/Config/Style.dart';
import 'package:flutter_app_hyuabot_v2/Model/FoodMenu.dart';
import 'package:flutter_app_hyuabot_v2/Model/Shuttle.dart';
import 'package:flutter_app_hyuabot_v2/Page/BusPage.dart';
import 'package:flutter_app_hyuabot_v2/Page/CalendarPage.dart';
import 'package:flutter_app_hyuabot_v2/Page/MapPage.dart';
import 'package:flutter_app_hyuabot_v2/Page/MetroPage.dart';
import 'package:flutter_app_hyuabot_v2/Page/PhoneSearchPage.dart';
import 'package:flutter_app_hyuabot_v2/Page/ReadingRoomPage.dart';
import 'package:flutter_app_hyuabot_v2/Page/SettingPage.dart';
import 'package:flutter_app_hyuabot_v2/Page/FoodPage.dart';
import 'package:flutter_app_hyuabot_v2/Page/ShuttlePage.dart';
import 'package:flutter_app_hyuabot_v2/UI/CustomCard.dart';
import 'package:flutter_app_hyuabot_v2/UI/CustomScrollPhysics.dart';

Future<dynamic> onLaunchMessageHandler(Map<String, dynamic> msg) async {
  final dynamic data = msg['data'];
  fcmManager.unsubscribeFromTopic(data['name']);
  prefManager.setBool(data['name'], false);
  readingRoomController.fetchAlarm();
}

Future<dynamic> backgroundMessageHandler(Map<String, dynamic> msg) async {
  final dynamic data = msg['data'];
  print("background:$data");
  _showNotificationWithNoTitle(data['name'], data['language']);
}

Future<dynamic> foregroundMessageHandler(Map<String, dynamic> msg) async{
  final dynamic data = msg['data'];
  print("foreground:$data");
  fcmManager.unsubscribeFromTopic(data['name']);
  prefManager.setBool(data['name'], false);
  _showNotificationWithNoTitle(data['name'], data['language']);
  readingRoomController.fetchAlarm();
}

Future<void> _showNotificationWithNoTitle(String msg, String language) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails('kobuggi.app/reading_room_notification', 'Reading Room Alarm', 'Alarm for reading room empty seats', importance: Importance.max, priority: Priority.high, ticker: 'ticker');
  const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics,);
  String _msg="Alarm";
  switch(language){
    case "ko":
      _msg = "${msg.tr}에서 자리가 발견되었다냥!";
      break;
    case "en":
      _msg = "Empty seat found from ${msg.tr}!";
      break;
    case "zh":
      _msg = "${msg.tr}";
      break;
  }
  flutterLocalNotificationsPlugin.show(0, null, _msg, platformChannelSpecifics, payload: msg);
}

class HomePage extends StatelessWidget{
  bool get didNotificationLaunchApp => notificationAppLaunchDetails?.didNotificationLaunchApp ?? false;

  @override
  Widget build(BuildContext context) {
    analytics.setCurrentScreen(screenName: "/home");
    // FCM
    fcmManager = FirebaseMessaging();
    fcmManager.configure(
        onMessage: foregroundMessageHandler,
        onBackgroundMessage: backgroundMessageHandler,
        onLaunch: onLaunchMessageHandler
    );


    // 화면 너비, 크기 조정
    final double _width = MediaQuery.of(context).size.width;
    final double _height = MediaQuery.of(context).size.height;
    final Color _primaryColor = Theme.of(context).accentColor;

    // 메뉴 아이콘 너비, 높이
    final double _itemWidth = _width / 5.5;
    final double _itemHeight = _width / 5.5;

    // 식당 이름들
    final _cafeteriaNames = ["student_cafeteria".tr, "teacher_cafeteria".tr, "food_court".tr, "changbo_cafeteria".tr, "dorm_cafeteria".tr];
    final _cafeteriaKeys = ["student_erica", "teacher_erica", "food_court_erica", "changbo_erica", "dorm_erica"];


    final Widget _shuttleCardList = Container(
      height: _height / 4,
      width: _width,
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: GetBuilder<ShuttleDepartureController>(
        init: ShuttleDepartureController(),
        builder: (controller) {
          if (controller.departureInfo.keys.isEmpty) {
            return Center(child: CircularProgressIndicator());
          } else {
            List<dynamic> residenceStn = List.from(controller.departureInfo["Residence"].shuttleListStation)..addAll(controller.departureInfo["Residence"].shuttleListCycle)..sort();
            List<dynamic> residenceTerminal = List.from(controller.departureInfo["Residence"].shuttleListTerminal)..addAll(controller.departureInfo["Residence"].shuttleListCycle)..sort();
            List<dynamic> schoolStn = List.from(controller.departureInfo["Shuttlecock_O"].shuttleListStation)..addAll(controller.departureInfo["Shuttlecock_O"].shuttleListCycle)..sort();
            List<dynamic> schoolTerminal = List.from(controller.departureInfo["Shuttlecock_O"].shuttleListTerminal)..addAll(controller.departureInfo["Shuttlecock_O"].shuttleListCycle)..sort();
            List<dynamic> station = List.from(controller.departureInfo["Subway"].shuttleListStation)..addAll(controller.departureInfo["Subway"].shuttleListCycle)..sort();
            List<dynamic> terminal = List.from(controller.departureInfo["YesulIn"].shuttleListTerminal)..addAll(controller.departureInfo["YesulIn"].shuttleListCycle)..sort();
            List<dynamic> schoolResidence = List.from(controller.departureInfo["Shuttlecock_I"].shuttleListStation)..addAll(controller.departureInfo["Shuttlecock_I"].shuttleListTerminal)..addAll(controller.departureInfo["Shuttlecock_I"].shuttleListCycle)..sort();
            List<Set<dynamic>> allShuttleList = [residenceStn.toSet(), residenceTerminal.toSet(), schoolStn.toSet(), schoolTerminal.toSet(), station.toSet(), terminal.toSet(), schoolResidence.toSet()];
            List<String> stopList = [
              "${"bus_stop_dorm".tr} → ${"bus_stop_station".tr}",
              "${"bus_stop_dorm".tr} → ${"bus_stop_terminal".tr}",
              "${"bus_stop_school".tr} → ${"bus_stop_station".tr}",
              "${"bus_stop_school".tr} → ${"bus_stop_terminal".tr}",
              "bus_stop_station".tr,
              "bus_stop_terminal".tr,
              "bus_stop_school_opposite".tr
            ];
            List<ShuttleStopDepartureInfo> data = [
              controller.departureInfo["Residence"],
              controller.departureInfo["Residence"],
              controller.departureInfo["Shuttlecock_O"],
              controller.departureInfo["Shuttlecock_O"],
              controller.departureInfo["Subway"],
              controller.departureInfo["YesulIn"],
              controller.departureInfo["Shuttlecock_I"]
            ];
            return ListView.builder(
              padding: EdgeInsets.only(top: 5, bottom: 5, right: 5),
              shrinkWrap: true,
              itemCount: 7,
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return _homeShuttleItems(context, stopList[index], allShuttleList[index].map((e) => e.toString()).toList(), data[index]);
              },
            );
          }
        },
      ),
    );

    final Widget _homeFoodMenu = GetBuilder<FoodInfoController>(
        init: FoodInfoController(),
        builder: (controller) {
          if (controller.menuList.keys.isEmpty) {
            controller.onInit();
            return Center(child: CircularProgressIndicator());
          }
          // food info
          Map<String, Map<String, List<FoodMenu>>> allMenus = controller.menuList;
          return Container(
            height: _height / 3.5,
            width: _width,
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: ListView.builder(
              padding: EdgeInsets.only(top: 5, bottom: 5, right: 5),
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
                      "breakfast".tr,
                      index,
                      allMenus[_cafeteriaKeys[index]]['breakfast']
                          .elementAt(0));
                } else if (_now.hour > 15 &&
                    allMenus[_cafeteriaKeys[index]]['dinner'].isNotEmpty) {
                  return _foodItems(
                      context,
                      _cafeteriaNames[index],
                      "dinner".tr,
                      index,
                      allMenus[_cafeteriaKeys[index]]['dinner'].elementAt(0));
                } else if (allMenus[_cafeteriaKeys[index]]['lunch']
                    .isNotEmpty) {
                  return _foodItems(
                      context,
                      _cafeteriaNames[index],
                      "lunch".tr,
                      index,
                      allMenus[_cafeteriaKeys[index]]['lunch'].elementAt(0));
                }
                return _foodItems(context, _cafeteriaNames[index],
                    "lunch".tr, index, null);
              },
            ),
          );
        });

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        elevation: 3,
        onPressed: () => Get.to(SettingPage()),
        label: Text(
          "setting_title".tr,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
        ),
        icon: Icon(Icons.settings, color: Colors.white),
        backgroundColor: _primaryColor,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: MainAppBar(),
      body: DoubleBackToCloseApp(
        snackBar: SnackBar(content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("back_snack_msg".tr, textAlign: TextAlign.center,),
          ],
        )),
        child: ScrollConfiguration(
          behavior: CustomScrollPhysics(),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              width: _width,
              color: Theme.of(context).backgroundColor,
              child: GetBuilder<ExpandMenuController>(
                init: ExpandMenuController(),
                builder: (controller) {
                  return Column(
                    children: [
                      Container(
                        height: 90,
                        padding: EdgeInsets.symmetric(
                            horizontal: 30, vertical: 10),
                        child: NativeAdmob(
                          adUnitID: AdManager.bannerAdUnitId,
                          numberAds: 1,
                          controller: adController,
                          type: NativeAdmobType.banner,
                          error: Center(
                              child: Text(
                                "plz_enable_ad".tr,
                                style: TextStyle(
                                    color: Theme
                                        .of(context)
                                        .textTheme
                                        .bodyText1
                                        .color,
                                    fontSize: 14),
                                textAlign: TextAlign.center,
                              )),
                          options: NativeAdmobOptions(
                            adLabelTextStyle: NativeTextStyle(
                              color: Theme
                                  .of(context)
                                  .textTheme
                                  .bodyText1
                                  .color,
                            ),
                            bodyTextStyle: NativeTextStyle(
                                color: Theme
                                    .of(context)
                                    .textTheme
                                    .bodyText1
                                    .color),
                            headlineTextStyle: NativeTextStyle(
                                color: Theme
                                    .of(context)
                                    .textTheme
                                    .bodyText1
                                    .color),
                            advertiserTextStyle: NativeTextStyle(
                                color: Theme
                                    .of(context)
                                    .textTheme
                                    .bodyText1
                                    .color),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 30, vertical: 10),
                        child: GestureDetector(
                          onTap: _expand,
                          child: Row(
                            children: <Widget>[
                              Text("menu_list".tr,
                                  style: TextStyle(
                                      fontSize: 18,
                                      color:
                                      Theme
                                          .of(context)
                                          .textTheme
                                          .bodyText1
                                          .color)),
                              Expanded(child: Container()),
                              GetBuilder<ExpandMenuController>(
                                  builder: (controller) {
                                    return Text(
                                      controller.isExpanded
                                          ? "shrink_menu".tr
                                          : "expand_menu".tr,
                                      style: TextStyle(color: Theme
                                          .of(context)
                                          .backgroundColor == Colors.white
                                          ? _primaryColor
                                          : Colors.white,
                                          fontFamily: 'Godo',
                                          fontSize: 18),
                                    );
                                  }
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 15),
                        child: AnimatedCrossFade(
                        crossFadeState: controller.isExpanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                        duration: kThemeAnimationDuration,
                        firstChild: GridView.count(
                        physics: NeverScrollableScrollPhysics(),
                        crossAxisCount: 4,
                        shrinkWrap: true,
                        childAspectRatio: 0.7,
                        children: [
                          _menuButton(context, _itemWidth, _itemHeight, "assets/images/hanyang-shuttle.png", "shuttle_btn".tr, ShuttlePage(), Theme.of(context).backgroundColor == Colors.white ? _primaryColor.withOpacity(0.3) : Colors.white30),
                          _menuButton(context, _itemWidth, _itemHeight, "assets/images/hanyang-bus.png", "bus_btn".tr, BusPage(), Theme.of(context).backgroundColor == Colors.white ? _primaryColor.withOpacity(0.3) : Colors.white30),
                          _menuButton(context, _itemWidth, _itemHeight, "assets/images/hanyang-metro.png", "metro_btn".tr, MetroPage(), Theme.of(context).backgroundColor == Colors.white ? _primaryColor.withOpacity(0.3) : Colors.white30),
                          _menuButton(context, _itemWidth, _itemHeight, "assets/images/hanyang-food.png", "food_btn".tr, FoodPage(), Theme.of(context).backgroundColor == Colors.white ? _primaryColor.withOpacity(0.3) : Colors.white30),
                          _menuButton(context, _itemWidth, _itemHeight, "assets/images/hanyang-reading-room.png", "reading_room_btn".tr, ReadingRoomPage(), Theme.of(context).backgroundColor == Colors.white ? _primaryColor.withOpacity(0.3) : Colors.white30),
                          _menuButton(context, _itemWidth, _itemHeight, "assets/images/hanyang-phone.png", "contact_btn".tr, Container(), Theme.of(context).backgroundColor == Colors.white ? _primaryColor.withOpacity(0.3) : Colors.white30),
                          _menuButton(context, _itemWidth, _itemHeight, "assets/images/hanyang-map.png", "map_btn".tr, MapPage(), Theme.of(context).backgroundColor == Colors.white ? _primaryColor.withOpacity(0.3) : Colors.white30),
                          _menuButton(context, _itemWidth, _itemHeight, "assets/images/hanyang-reading-room.png", "calendar_btn".tr, CalendarPage(), Theme.of(context).backgroundColor == Colors.white ? _primaryColor.withOpacity(0.3) : Colors.white30),
                        ]),
                        secondChild: GridView.count(
                          physics: NeverScrollableScrollPhysics(),
                          crossAxisCount: 4,
                          shrinkWrap: true,
                          childAspectRatio: 0.8,
                          children: [
                            _menuButton(context, _itemWidth, _itemHeight, "assets/images/hanyang-shuttle.png", "shuttle_btn".tr, ShuttlePage(), Theme.of(context).backgroundColor == Colors.white ? _primaryColor.withOpacity(0.3) : Colors.white30),
                            _menuButton(context, _itemWidth, _itemHeight, "assets/images/hanyang-bus.png", "bus_btn".tr, BusPage(), Theme.of(context).backgroundColor == Colors.white ? _primaryColor.withOpacity(0.3) : Colors.white30),
                            _menuButton(context, _itemWidth, _itemHeight, "assets/images/hanyang-metro.png", "metro_btn".tr, MetroPage(), Theme.of(context).backgroundColor == Colors.white ? _primaryColor.withOpacity(0.3) : Colors.white30),
                            _menuButton(context, _itemWidth, _itemHeight, "assets/images/hanyang-food.png", "food_btn".tr, FoodPage(), Theme.of(context).backgroundColor == Colors.white ? _primaryColor.withOpacity(0.3) : Colors.white30)
                          ]),
                        ),
                      ),
                      Divider(),
                      Container(
                        margin: EdgeInsets.only(left: 30, right: 30, top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("shuttle_list".tr,
                                style: TextStyle(
                                    fontSize: 18,
                                    color:
                                    Theme
                                        .of(context)
                                        .textTheme
                                        .bodyText1
                                        .color)),
                            GestureDetector(
                                onTap: () {
                                  Get.to(ShuttlePage());
                                },
                                child: Text("show_all_shuttle".tr,
                                  style: TextStyle(color: Theme
                                      .of(context)
                                      .backgroundColor == Colors.white
                                      ? _primaryColor
                                      : Colors.white,
                                    fontFamily: 'Godo',
                                    fontSize: 18,),)
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      _shuttleCardList,
                      Divider(),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 30, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("food_now".tr,
                                style: TextStyle(
                                    fontSize: 18,
                                    color:
                                    Theme
                                        .of(context)
                                        .textTheme
                                        .bodyText1
                                        .color)),
                            GestureDetector(
                                onTap: () {
                                  Get.to(FoodPage());
                                },
                                child: Text(
                                  "show_all_food".tr,
                                  style: TextStyle(
                                    color: Theme
                                        .of(context)
                                        .backgroundColor ==
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
                  );
                }
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _expand() {
    Get.find<ExpandMenuController>().expand();
  }

  Widget _menuButton(BuildContext context, double width, double height, String assetName, String menuName, Widget newPage, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: (){Get.to(newPage);},
          child: Container(
            width: width,
            height: height,
            child: Image.asset(
              assetName,
            ),
            decoration: BoxDecoration(
                color: color, borderRadius: BorderRadius.circular(10)),
            padding: EdgeInsets.all(5),
          ),
        ),
        Flexible(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              menuName,
              style: TextStyle(
              color: Theme.of(context).textTheme.bodyText1.color, fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
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

class ExpandMenuController extends GetxController{
  bool isExpanded = true;

  expand(){
    isExpanded = !isExpanded;
    update();
  }
}