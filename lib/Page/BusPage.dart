import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app_hyuabot_v2/Bloc/BusController.dart';
import 'package:flutter_app_hyuabot_v2/Config/AdManager.dart';
import 'package:flutter_app_hyuabot_v2/Config/GlobalVars.dart';
import 'package:flutter_app_hyuabot_v2/Page/BusTimeTablePage.dart';
import 'package:flutter_app_hyuabot_v2/UI/CustomPaint/BusCardPaint.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_options.dart';
import 'package:get/get.dart';

class BusPage extends StatelessWidget {
  Widget _busCard(BuildContext context, double width, String busStop, String terminalStop, String lineName, Color lineColor, Map<String, dynamic> data, bool timeTableOffered){
    String _boundString;
    switch(prefManager.read("localeCode")){
      case "ko_KR":
        _boundString = "$terminalStop 방면";
        break;
      case "en_US":
        _boundString = "Bound for $terminalStop";
        break;
      case "zh":
        _boundString = "$terminalStop";
        break;
    }
    return GestureDetector(
      onTap: (){
        if(timeTableOffered){
          Get.to(BusTimeTablePage(lineName, lineColor));
        }else {
          Get.showSnackbar(GetBar(messageText: Text("timetable_not_offered_popup".tr)));
        }
      },
      child: Card(
        color: Theme.of(context).backgroundColor == Colors.black ? Colors.black : Colors.white,
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(child: Text(lineName, style: TextStyle(color: lineColor, fontSize: 25),), padding: const EdgeInsets.only(top: 10),),
                  SizedBox(width: 10,),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Text(busStop, style: TextStyle(fontSize: 16, color: Theme.of(context).backgroundColor == Colors.white ? Colors.black : Colors.white,),),
                        ),
                        Text(_boundString, style: TextStyle(fontSize: 12, color: Colors.grey),),
                      ],
                    ),
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    final _busController = Get.put(BusDepartureController());
    _busController.queryDepartureInfo();
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: Obx(
          () {
            print(_busController.departureInfo);
            if(_busController.departureInfo == null){
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
                  _busCard(context, _width, "guest_house".tr, "sangnoksu_stn".tr, "10-1", Color(0xff009e96), _busController.departureInfo['10-1'], true),
                  _busCard(context, _width, "guest_house".tr, "gangnam_stn".tr, "3102", Color(0xffe60012), _busController.departureInfo['3102'], true),
                  _busCard(context, _width, "main_gate".tr, "suwon_stn".tr, "707-1", Color(0xff0068b7), _busController.departureInfo['707-1'], false),
                  Expanded(
                    // child: Container(),
                    child: Center(child: Text("how_use_bus_page".tr, style: TextStyle(color: Theme.of(context).textTheme.bodyText1.color), textAlign: TextAlign.center,)),
                  ),
                  Container(
                    height: 90,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    child: NativeAdmob(
                      adUnitID: AdManager.bannerAdUnitId,
                      numberAds: 1,
                      controller: adController,
                      type: NativeAdmobType.banner,
                      error: Center(child: Text("plz_enable_ad".tr, style: TextStyle(color: Theme.of(context).textTheme.bodyText1.color, fontSize: 14), textAlign: TextAlign.center,)),
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
}