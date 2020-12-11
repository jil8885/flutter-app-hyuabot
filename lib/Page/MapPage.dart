import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app_hyuabot_v2/Bloc/DatabaseController.dart';
import 'package:flutter_app_hyuabot_v2/Config/GlobalVars.dart';
import 'package:flutter_app_hyuabot_v2/Config/Localization.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';


class MapPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MapPageState();
}
class _MapPageState extends State<MapPage>{
  BuildContext _context;
  DataBaseController _dataBaseController;
  List<Marker> _markers = [];

  @override
  void initState(){
    super.initState();
  }

  _getMarkers(String category) async {
    var _markerList;
    _markerList = await _dataBaseController.fetchMarkers(category);
    setState(() {
      _markers = _markerList;
    });
  }


  @override
  Widget build(BuildContext context) {
    Fluttertoast.showToast(msg: TranslationManager.of(context).trans("map_start_dialog"));
    _dataBaseController = DataBaseController(context);
    _context = context;
    _dataBaseController.init().whenComplete(() {});
    return Scaffold(
      floatingActionButton: FloatingActionButton(child: Icon(Icons.category, color: Colors.white,), backgroundColor: Color(0xff2db400), onPressed: _menuButtonPressed,),
      body: Container(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          child: Container(child: _naverMap(context))
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  _naverMap(BuildContext context){
      return NaverMap(
        markers: _markers,
        initialCameraPosition: CameraPosition(target: LatLng(37.300153, 126.837759), zoom: 17.5),
        mapType: MapType.Basic,
        symbolScale: 0,
        nightModeEnable: Theme.of(context).backgroundColor == Colors.black,
      );
  }

  _menuButtonPressed(){
    showMaterialModalBottomSheet(
        context: _context,
        backgroundColor: Color.fromARGB(255, 20, 75, 170),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
        builder: (context) => Container(
          margin: EdgeInsets.only(top: 20, left: 10, right: 10),
          height: 275,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _menuButton('korean'),
                  _menuButton('japanese'),
                  _menuButton('chinese'),
                  _menuButton('western'),
                ],              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _menuButton('fast_food'),
                  _menuButton('chicken'),
                  _menuButton('pizza'),
                  _menuButton('meat'),

                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _menuButton('vietnamese'),
                  _menuButton('other_food'),
                  _menuButton('bakery'),
                  _menuButton('cafe'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _menuButton('pub'),
                  SizedBox(width: 72,),
                  SizedBox(width: 72,)
                ],
              )
            ],
          )
        )
    );
  }

  Widget _menuButton(String menuName){
    String _toastString;
    switch(prefManager.getString("localeCode", defaultValue: "ko_KR").getValue()){
      case "ko_KR":
        _toastString = '${TranslationManager.of(context).trans(menuName)}(으)로 전환되었습니다.';
        break;
      case "en_US":
        _toastString = 'Changed to ${TranslationManager.of(context).trans(menuName)}.';
        break;
      case "zh":
        _toastString = '${TranslationManager.of(context).trans(menuName)}(으)로 전환되었습니다.';
        break;
    }
    return Column(
      children: [
        GestureDetector(
          onTap: (){
            _markers.clear();
            _getMarkers(menuName);
            Get.back();
            Fluttertoast.showToast(msg: _toastString);
          },
          child: Card(
            elevation: 3,
            color: Colors.white54,
            clipBehavior: Clip.antiAlias,
            child: Container(
              height: 60,
              width: 85,
              padding: EdgeInsets.all(10),
              child: Center(child: Text(TranslationManager.of(context).trans(menuName).replaceAll(" ", "\n"), style: TextStyle(color: Colors.white, fontSize: 15), textAlign: TextAlign.center,))
            ),
          ),
        ),
      ],
    );
  }
}