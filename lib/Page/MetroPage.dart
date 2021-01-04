import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app_hyuabot_v2/Bloc/MetroController.dart';
import 'package:flutter_app_hyuabot_v2/Config/GlobalVars.dart';
import 'package:flutter_app_hyuabot_v2/Config/Localization.dart';
import 'package:flutter_app_hyuabot_v2/UI/CustomPaint/MetroCardPaint.dart';
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

    return Card(
      color: Theme.of(context).backgroundColor == Colors.black ? Colors.black : Colors.white,
      elevation: 3,
      child: Container(
        width: width - 50,
        padding: EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 10),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 5),
              child: Text(currentStop, style: TextStyle(fontSize: 16, color: Theme.of(context).backgroundColor == Colors.white ? Colors.black : Colors.white),),
            ),
            Text(_boundString, style: TextStyle(fontSize: 12, color: Colors.grey),),
            Divider(color: Colors.grey),
            Container(child: CustomPaint(painter: content,), padding: EdgeInsets.only(bottom: 10), height: 50,)
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
                        IconButton(icon: Icon(Icons.arrow_back_rounded, color: Theme.of(context).textTheme.bodyText1.color,), onPressed: (){Get.back();}, padding: EdgeInsets.only(left: 20), alignment: Alignment.centerLeft)
                      ],
                    ),
                    Flexible(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            _metroCard(_width, _height, Color(0xff00a5de), TranslationManager.of(context).trans("station_line_4"), TranslationManager.of(context).trans("bound_seoul"), snapshot.data['main']['up']),
                            _metroCard(_width, _height, Color(0xff00a5de), TranslationManager.of(context).trans("station_line_4"), TranslationManager.of(context).trans("bound_oido"), snapshot.data['main']['down']),
                            _metroCard(_width, _height, Color(0xfff5a200), TranslationManager.of(context).trans("station_line_suin"), TranslationManager.of(context).trans("bound_suwon"), snapshot.data['sub']['up']),
                            _metroCard(_width, _height, Color(0xfff5a200), TranslationManager.of(context).trans("station_line_suin"), TranslationManager.of(context).trans("bound_incheon"), snapshot.data['sub']['down']),
                            Container(
                              padding: EdgeInsets.all(10),
                              height: 80,
                              width: _width,
                              child: Text(TranslationManager.of(context).trans("subway_caution"), textAlign: TextAlign.center, style: TextStyle(color: Colors.grey),),
                            ),
                          ],
                        ),
                      ),
                    )
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