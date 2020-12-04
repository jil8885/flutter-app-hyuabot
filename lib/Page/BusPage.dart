import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app_hyuabot_v2/Bloc/BusController.dart';
import 'package:flutter_app_hyuabot_v2/Config/AdManager.dart';
import 'package:flutter_app_hyuabot_v2/Config/GlobalVars.dart';
import 'package:flutter_app_hyuabot_v2/UI/CustomPaint/BusCardPaint.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_options.dart';
import 'package:get/get.dart';

class BusPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BusPageState();

}
class _BusPageState extends State<BusPage> with SingleTickerProviderStateMixin{
  Timer _busTimer;
  FetchBusInfoController _busInfoController;
  BuildContext _context;


  Widget _busCard(double width, String busStop, String terminalStop, String lineName, Color lineColor, Map<String, dynamic> data, bool timeTableOffered){
    return Card(
      color: Theme.of(_context).backgroundColor == Colors.black ? Colors.black : Colors.white,
      elevation: 3,
      child: Container(
        width: width - 50,
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5,),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(child: Text(lineName, style: TextStyle(color: lineColor, fontSize: 25, fontFamily: "Godo"),), padding: const EdgeInsets.only(top: 10), width: width / 4.5,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Text(busStop, style: TextStyle(fontSize: 16, fontFamily: "Godo", color: Theme.of(_context).backgroundColor == Colors.white ? Colors.black : Colors.white,),),
                    ),
                    Text("$terminalStop 방면", style: TextStyle(fontSize: 12, fontFamily: "Godo", color: Colors.grey),),
                  ],
                ),
              ],
            ),
            Divider(color: Colors.grey),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: CustomPaint(painter: BusCardPaint(data, lineColor, context, timeTableOffered), size: Size(width - 50, 50), ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    _context = context;
    _busInfoController = FetchBusInfoController();
    _busTimer = Timer.periodic(Duration(minutes: 1), (timer) {
      _busInfoController.fetch();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: StreamBuilder<Map<String, dynamic>>(
          stream: _busInfoController.allBusInfo,
          builder: (context, snapshot) {
            if(snapshot.hasError){
              return Center(child: Text("버스 정보를 불러오는데 실패했습니다.", style: Theme.of(context).textTheme.bodyText1,),);
            } else if(!snapshot.hasData){
              return Center(child: CircularProgressIndicator(),);
            }
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [IconButton(icon: Icon(Icons.arrow_back_rounded, color: Theme.of(context).textTheme.bodyText1.color,), onPressed: (){Get.back();}, padding: EdgeInsets.only(left: 30),)],
                  ),
                  _busCard(_width, "한양대게스트하우스", "상록수역", "10-1", Color(0xff009e96), snapshot.data['10-1'], true),
                  _busCard(_width, "한양대게스트하우스", "강남역", "3102", Color(0xffe60012), snapshot.data['3102'], true),
                  _busCard(_width, "한양대정문", "수원역", "707-1", Color(0xff0068b7), snapshot.data['707-1'], false),
                  Expanded(
                    child: Center(child: Text("버스 시간표 등 기타 정보는\n각 노선을 터치해보세요!", style: TextStyle(color: Theme.of(context).textTheme.bodyText1.color), textAlign: TextAlign.center,)),
                  ),
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
    _busTimer.cancel();
    _busInfoController.dispose();
    super.dispose();
  }
}