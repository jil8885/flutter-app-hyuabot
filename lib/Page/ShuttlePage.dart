import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_hyuabot_v2/Config/AdManager.dart';
import 'package:flutter_app_hyuabot_v2/Config/GlobalVars.dart';
import 'package:flutter_app_hyuabot_v2/Model/Shuttle.dart';
import 'package:flutter_app_hyuabot_v2/UI/CustomPaint/ShuttlePaint.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_options.dart';

class ShuttlePage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    final double _statusBarHeight = MediaQuery.of(context).padding.top;
    final List<String> _busStopList = ["기숙사", "셔틀콕", "한대앞", "예술인", "셔틀콕 건너편"];
    final TextStyle _theme1 = Theme.of(context).textTheme.bodyText1;
    final TextStyle _theme2 = Theme.of(context).textTheme.bodyText2;
    Timer.periodic(Duration(minutes: 1), (timer) {
      shuttleController.fetch();
    });
    
    return Material(
      child: Container(
        color: Theme.of(context).backgroundColor,
        child: Column(
          children: [
            SizedBox(height: _statusBarHeight,),
            Container(
              height: MediaQuery.of(context).size.width * .15,
              child: Row(children: [
                  SizedBox(width: 90, child: Text("정류장", style: Theme.of(context).textTheme.bodyText2, textAlign: TextAlign.center,),),
                  SizedBox(width: MediaQuery.of(context).size.width * .075,),
                  Text("한대앞행", style: _theme2,),
                  SizedBox(width: MediaQuery.of(context).size.width * .0875,),
                  Text("예술인행", style: _theme2,),
                  SizedBox(width: MediaQuery.of(context).size.width * .0875,),
                  Text("순환버스", style: _theme2,),
                ],
              ),
              color: Theme.of(context).accentColor,
            ),
            Expanded(
              child: Stack(
                children: [
                  StreamBuilder<Map<String, ShuttleStopDepartureInfo>>(
                    stream: shuttleController.allShuttleInfo,
                    builder: (context, snapshot) {
                      if(snapshot.hasError){
                        return CircularProgressIndicator();
                      }
                      return CustomPaint(
                        painter: ShuttlePaint(snapshot.data, context),
                        size: MediaQuery.of(context).size,
                      );
                    }
                  ),
                  Column(
                    children: [
                      ListView.separated(
                        itemCount: 5,
                        shrinkWrap: true,
                        itemBuilder: (context, index){
                          return GestureDetector(
                            onTap: (){
                              print(_busStopList[index]);
                            },
                            child: Container(
                              height: MediaQuery.of(context).size.height * .1,
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.symmetric(horizontal: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  ListTile(
                                    title: Text(_busStopList[index].replaceAll(" ", "\n"), style: TextStyle(color: _theme1.color, fontFamily: "Godo", fontSize: 18), textAlign: TextAlign.left)
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => Container(height: 0.1, color: Colors.grey, margin: EdgeInsets.symmetric(horizontal: 20),),
                      ),
                      SizedBox(height: 45,),
                      Text("셔틀 시간표는 시간표 기반으로 제공합니다.\n정류장에 1~2분 먼저 도착하는 것을 권장합니다.", style: Theme.of(context).textTheme.bodyText1, textAlign: TextAlign.center,),
                      SizedBox(height: 25,),
                      Text("정류장 위치 및 전체 시간표, 첫막차 정보는\n정류장을 클릭하시면 확인할 수 있습니다.", style: Theme.of(context).textTheme.bodyText1, textAlign: TextAlign.center,),
                      Expanded(child: Container(),),
                      Container(
                        height: 85,
                        padding: EdgeInsets.symmetric(horizontal: 30),
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
                ],
              )
            )
          ],
        ),
      ),
    );
  }
}