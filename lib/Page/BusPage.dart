import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app_hyuabot_v2/Config/AdManager.dart';
import 'package:flutter_app_hyuabot_v2/Config/GlobalVars.dart';
import 'package:flutter_app_hyuabot_v2/Page/BusTimeTablePage.dart';
import 'package:flutter_app_hyuabot_v2/UI/CustomPaint/BusCardPaint.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_options.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:transition/transition.dart';

class BusPage extends StatelessWidget {
  Widget _busCard(BuildContext context, double width, String busStop, String terminalStop, String lineName, Color lineColor, bool timeTableOffered){
    String _boundString;
    switch(prefManager.getString("localeCode")){
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
          Navigator.push(context, Transition(child: BusTimeTablePage(lineName, lineColor), transitionEffect: TransitionEffect.leftToRight).builder());
        }else {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text("timetable_not_offered_popup".tr(), style: TextStyle(color: Theme.of(context).backgroundColor==Colors.black?Colors.white:Colors.black), textAlign: TextAlign.center,),
              backgroundColor: Theme.of(context).backgroundColor,
              duration: Duration(seconds: 2),
            )
          );
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
                child: StreamBuilder(
                  stream: busDepartureController.busDepartureInfo,
                  builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if(snapshot.hasError){
                      return Container(child: Center(child: Text("loading_error".tr()),), height: 50,);
                    } else if(!snapshot.hasData){
                      return Container(child: Center(child: LinearProgressIndicator(),), height: 50,);
                    } else {
                      return CustomPaint(painter: BusCardPaint(snapshot.data[lineName], lineColor, context, timeTableOffered), size: Size(width - 50, 50), );
                    }
                  },
                )
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

    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [IconButton(
                      icon: Icon(Icons.arrow_back_rounded,
                      color: Theme.of(context).textTheme.bodyText2.color,),
                      onPressed: (){Navigator.pop(context);},
                      padding: EdgeInsets.only(left: 30),)],
                  ),
                  _busCard(context, _width, "guest_house".tr(), "sangnoksu_stn".tr(), "10-1", Color(0xff009e96), true),
                  _busCard(context, _width, "guest_house".tr(), "gangnam_stn".tr(), "3102", Color(0xffe60012), true),
                  _busCard(context, _width, "main_gate".tr(), "suwon_stn".tr(), "707-1", Color(0xff0068b7), false),
                  Expanded(
                    // child: Container(),
                    child: Center(child: Text("how_use_bus_page".tr(), style: TextStyle(color: Theme.of(context).textTheme.bodyText2.color), textAlign: TextAlign.center,)),
                  ),
                  Container(
                    height: 90,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    child: NativeAdmob(
                      adUnitID: AdManager.bannerAdUnitId,
                      numberAds: 1,
                      controller: adController,
                      type: NativeAdmobType.banner,
                      error: Center(child: Text("plz_enable_ad".tr(), style: TextStyle(color: Theme.of(context).textTheme.bodyText2.color, fontSize: 14), textAlign: TextAlign.center,)),
                      options: NativeAdmobOptions(
                        adLabelTextStyle: NativeTextStyle(color: Theme.of(context).textTheme.bodyText2.color,),
                        bodyTextStyle: NativeTextStyle(color: Theme.of(context).textTheme.bodyText2.color),
                        headlineTextStyle: NativeTextStyle(color: Theme.of(context).textTheme.bodyText2.color),
                        advertiserTextStyle: NativeTextStyle(color: Theme.of(context).textTheme.bodyText2.color),
                      ),
                    ),
                  ),
                ],
              ),
            )
      ),
    );
  }
}