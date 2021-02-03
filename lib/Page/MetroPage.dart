import 'package:flutter/material.dart';
import 'package:flutter_app_hyuabot_v2/Bloc/MetroController.dart';
import 'package:flutter_app_hyuabot_v2/Config/GlobalVars.dart';
import 'package:flutter_app_hyuabot_v2/UI/CustomPaint/MetroCardPaint.dart';
import 'package:get/get.dart';

class MetroPage extends StatelessWidget {
  final FetchMetroInfoController _metroController = Get.put(FetchMetroInfoController());
  Widget _metroCard(double width, double height, Color lineColor, String currentStop, String terminalStop, String key, String subKey){
    CustomPainter content;

    try {
      var data = _metroController.departureInfo[key][subKey] as List;
      if (data.isNotEmpty) {
        if (data
            .elementAt(0)
            .runtimeType
            .toString() == 'MetroRealtimeInfo') {
          content = MetroRealtimeCardPaint(data, lineColor);
        } else {
          content = MetroTimeTableCardPaint(data, lineColor);
        }
      } else {
        content = MetroRealtimeCardPaint([], lineColor);
      }
    } catch(e) {
      content = null;
    }

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

    return Card(
      color: Get.isDarkMode ? Colors.black : Colors.white,
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
              child: Text(currentStop, style: TextStyle(fontSize: 16, color: !Get.isDarkMode ? Colors.black : Colors.white),),
            ),
            Text(_boundString, style: TextStyle(fontSize: 12, color: Colors.grey),),
            Divider(color: Colors.grey),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(child: _metroController.isLoading.value ? Center(child: CircularProgressIndicator()):CustomPaint(painter: content,), padding: EdgeInsets.only(bottom: 10), height: 50,),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    analytics.setCurrentScreen(screenName: "/metro");
    final double _width = MediaQuery.of(context).size.width;
    final double _height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: GetBuilder<FetchMetroInfoController>(
            builder: (controller) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(icon: Icon(Icons.arrow_back_rounded, color: Theme.of(context).textTheme.bodyText2.color,), onPressed: (){Get.back();}, padding: EdgeInsets.only(left: 20), alignment: Alignment.centerLeft)
                      ],
                    ),
                    Flexible(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            _metroCard(_width, _height, Color(0xff00a5de), "station_line_4".tr, "bound_seoul".tr, 'main', 'up'),
                            _metroCard(_width, _height, Color(0xff00a5de), "station_line_4".tr, "bound_oido".tr, 'main', 'down'),
                            _metroCard(_width, _height, Color(0xfff5a200), "station_line_suin".tr, "bound_suwon".tr, 'sub', 'up'),
                            _metroCard(_width, _height, Color(0xfff5a200), "station_line_suin".tr, "bound_incheon".tr, 'sub', 'down'),
                            Container(
                              padding: EdgeInsets.all(10),
                              height: 80,
                              width: _width,
                              child: Text("subway_caution".tr, textAlign: TextAlign.center, style: TextStyle(color: Colors.grey),),
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
}