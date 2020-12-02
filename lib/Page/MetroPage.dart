import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app_hyuabot_v2/Bloc/MetroController.dart';
import 'package:flutter_app_hyuabot_v2/Config/AdManager.dart';
import 'package:flutter_app_hyuabot_v2/Config/GlobalVars.dart';
import 'package:flutter_app_hyuabot_v2/Model/Metro.dart';
import 'package:flutter_app_hyuabot_v2/UI/CustomPaint/BusCardPaint.dart';
import 'package:flutter_app_hyuabot_v2/UI/CustomPaint/MetroCardPaint.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_options.dart';
import 'package:get/get.dart';

class MetroPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MetroPageState();

}
class _MetroPageState extends State<MetroPage> with SingleTickerProviderStateMixin{
  FetchMetroInfoController _metroInfoController;
  Timer _metroTimer;

  Widget _metroCard(double width, double height, Color lineColor, String currentStop, String terminalStop, dynamic data){
    CustomPainter content;
    if((data as List).elementAt(0).runtimeType.toString() == 'MetroRealtimeInfo'){
      content = MetroRealtimeCardPaint(data, lineColor, context);
    } else {
      content = MetroTimeTableCardPaint(data, lineColor, context);
    }

    return Card(
      color: Colors.white,
      elevation: 3,
      child: Container(
        width: width - 50,
        height: height / 6.5,
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 5),
              child: Text(currentStop, style: TextStyle(fontSize: 16, fontFamily: "Godo", color: Colors.black),),
            ),
            Text("$terminalStop 방면", style: TextStyle(fontSize: 12, fontFamily: "Godo", color: Colors.grey),),
            Divider(color: Colors.grey),
            Container(child: CustomPaint(painter: content,))
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    _metroInfoController = FetchMetroInfoController();
    _metroTimer = Timer.periodic(Duration(minutes: 1), (timer) {
      _metroInfoController.fetch();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    final double _height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: StreamBuilder<Map<String, dynamic>>(
            stream: _metroInfoController.allMetroInfo,
            builder: (context, snapshot) {
              if(snapshot.hasError){
                return Center(child: Text("지하철 정보를 불러오는데 실패했습니다.", style: Theme.of(context).textTheme.bodyText1,),);
              } else if(!snapshot.hasData){
                return Center(child: CircularProgressIndicator(),);
              }
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(icon: Icon(Icons.arrow_back_rounded, color: Theme.of(context).textTheme.bodyText1.color,), onPressed: (){Get.back();}, padding: EdgeInsets.only(left: 20),)
                      ],
                    ),
                    _metroCard(_width, _height, Color(0xff00a5de), "한대앞역(4호선)", "서울·당고개", snapshot.data['main']['up']),
                    _metroCard(_width, _height, Color(0xff00a5de), "한대앞역(4호선)", "안산·오이도", snapshot.data['main']['down']),
                    _metroCard(_width, _height, Color(0xfff5a200), "한대앞역(수인분당선)", "왕십리·수원", snapshot.data['sub']['up']),
                    _metroCard(_width, _height, Color(0xfff5a200), "한대앞역(수인분당선)", "오이도·인천", snapshot.data['sub']['down']),
                    Expanded(child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Center(child: Text("수인분당선은 실시간 API 문제로 시간표만 제공합니다", textAlign: TextAlign.center, style: TextStyle(color: Theme.of(context).textTheme.bodyText1.color),),)],
                    ),),
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
                  ],
                ),
              );
            }
        ),
      ),
    );
  }

  @override
  void dispose() {
    _metroTimer.cancel();
    _metroInfoController.dispose();
    super.dispose();
  }
}