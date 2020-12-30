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
  final _menus = ['korean', 'japanese', 'chinese', 'western', 'fast_food', 'chicken', 'pizza', 'meat', 'vietnamese', 'other_food', 'bakery', 'cafe', 'pub'];
  BuildContext _context;
  DataBaseController _dataBaseController;
  List<Marker> _markers = [];
  int _index;
  double _width;

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
    this._width = MediaQuery.of(context).size.width;
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
        backgroundColor: Color.fromARGB(255, 20, 75, 170).withOpacity(0.3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
        builder: (context) => Container(
          margin: EdgeInsets.all(10),
          height: 275,
          child: Column(
            children: [
              Flexible(
                child: ListWheelScrollView(
                  itemExtent: 65,
                  onSelectedItemChanged: (index){_index = index;},
                  children: _menus.map((e) => _menuButton(e)).toList(),
                  physics: FixedExtentScrollPhysics(),
                  useMagnifier: true,
                  magnification: 1.25,
                ),
              ),
              FlatButton(onPressed: (){
                String _toastString;
                switch(prefManager.getString("localeCode", defaultValue: "ko_KR").getValue()){
                  case "ko_KR":
                    _toastString = '${TranslationManager.of(context).trans(_menus[_index])}(으)로 전환되었습니다.';
                    break;
                  case "en_US":
                    _toastString = 'Changed to ${TranslationManager.of(context).trans(_menus[_index])}.';
                    break;
                  case "zh":
                    _toastString = '${TranslationManager.of(context).trans(_menus[_index])}(으)로 전환되었습니다.';
                    break;
                }
                  _markers.clear();
                  _getMarkers(_menus[_index]);
                  Get.back();
                  Fluttertoast.showToast(msg: _toastString);
                }, 
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), color: Colors.white),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [Text(TranslationManager.of(context).trans('save'))],
                    ),
                  )
              )
            ],
          )
        )
    );
  }

  Widget _menuButton(String menuName){
    return Container(
      height: 60,
      padding: EdgeInsets.all(2),
      child: Container(
          child: Center(child: Text(TranslationManager.of(context).trans(menuName), style: TextStyle(color: Colors.white, fontSize: 15), textAlign: TextAlign.center,))
      )
    );
  }
}
//
