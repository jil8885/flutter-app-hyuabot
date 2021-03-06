import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app_hyuabot_v2/Bloc/MapController.dart';
import 'package:flutter_app_hyuabot_v2/Config/GlobalVars.dart';
import 'package:flutter_material_pickers/helpers/show_scroll_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';
import 'package:easy_localization/easy_localization.dart';

class MapPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MapPageState();
}
class _MapPageState extends State<MapPage> {

  final _menus = ['korean', 'japanese', 'chinese', 'western', 'fast_food', 'chicken', 'pizza', 'meat', 'vietnamese', 'other_food', 'bakery', 'cafe', 'pub'];
  List<String>? _translatedMenus;

  MapController? _mapController;
  List<Marker> _markers = [];
  Widget? _map;
  bool _isInitial = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(prefManager!.getString("localeCode")!="ko_KR"){
      Fluttertoast.showToast(msg: "Sorry, this menu supports only korean!");
    }

    if(_isInitial){
      Fluttertoast.showToast(
          msg: "map_start_dialog".tr());
      _isInitial = false;
    }
    _mapController = MapController(context);
    _translatedMenus = _menus.map((e) => e.tr()).toList();
    String _selectedCat = _translatedMenus![0];
    _map = _naverMap(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.menu, color: Colors.white,),
        backgroundColor: Color(0xff2db400),
        onPressed: () {
          showMaterialScrollPicker(
            context: context,
            title: "map_picker_title".tr(),
            items: _translatedMenus,
            selectedItem: _translatedMenus![0],
            onChanged: (value) {
              _selectedCat = value;
            },
            onConfirmed: () {
              _markers.clear();
              _mapController!.getMarker(
                  _menus[_translatedMenus!.indexOf(_selectedCat)]);
              String? _toastString;
              switch (prefManager!.getString("localeCode")) {
                case "ko_KR":
                  _toastString = '$_selectedCat(으)로 전환되었습니다.';
                  break;
                case "en_US":
                  _toastString = 'Changed to $_selectedCat.';
                  break;
                case "zh":
                  _toastString = '$_selectedCat(으)로 전환되었습니다.';
                  break;
              }
              Fluttertoast.showToast(msg: _toastString!);
            },
          );
      }),
      body: Container(child: _map)
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  _naverMap(BuildContext context) {
    return StreamBuilder<List<Marker>>(
        stream: _mapController!.selectedMarkers,
        builder: (context, snapshot) {
          _markers = snapshot.data!;
          return NaverMap(
            markers: _markers,
            initialCameraPosition: CameraPosition(
                target: LatLng(37.300153, 126.837759), zoom: 16),
            mapType: MapType.Basic,
            symbolScale: 0,
            nightModeEnable: Theme
                .of(context)
                .backgroundColor == Colors.black,
            onMapCreated: _onMapCreated,
          );
        }
    );
  }

  void _onMapCreated(NaverMapController controller) {
  }

}