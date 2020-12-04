import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app_hyuabot_v2/Bloc/ShuttleController.dart';
import 'package:flutter_app_hyuabot_v2/Model/Shuttle.dart';
import 'package:flutter_app_hyuabot_v2/UI/CustomPaint/ShuttlePaint.dart';

class PhoneSearchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PhoneSearchPageState();

}
class _PhoneSearchPageState extends State<PhoneSearchPage>{
  FetchAllShuttleController _shuttleController;

  Widget _shuttleCard(double width, double height, String currentStop, String terminalStop, List timeTable, ShuttleStopDepartureInfo data){
    CustomPainter content = ShuttleCardPaint(timeTable, data, Color.fromARGB(255, 20, 75, 170), context);
    return Card(
      color: Colors.white,
      elevation: 3,
      child: Container(
        width: width * .9,
        height: height / 5.5,
        padding: EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 10),
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
            Container(child: CustomPaint(painter: content,), padding: EdgeInsets.only(bottom: 10),)
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    final double _height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: Container()
        ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}