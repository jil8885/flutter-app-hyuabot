import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app_hyuabot_v2/Bloc/MapController.dart';
import 'package:flutter_app_hyuabot_v2/Config/GlobalVars.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';
import 'package:flutter_picker/flutter_picker.dart';

class MapPage extends StatelessWidget {
  final _menus = ['korean', 'japanese', 'chinese', 'western', 'fast_food', 'chicken', 'pizza', 'meat', 'vietnamese', 'other_food', 'bakery', 'cafe', 'pub'];
  bool _isInit = false;
  List<String> _translatedMenus;

  MapController _mapController = Get.put(MapController());

  List<Marker> _markers = [];
  FloatingSearchBar _floatingSearchBar;
  FloatingSearchBarController _floatingSearchBarController = FloatingSearchBarController();
  OverlayImage image;


  @override
  Widget build(BuildContext context) {
    if(!_isInit){
      Fluttertoast.showToast(msg: "map_start_dialog".tr);
      _isInit = true;
    }
    analytics.setCurrentScreen(screenName: "/map");
    _translatedMenus = _menus.map((e) => e.tr).toList();
    _floatingSearchBar = buildFloatingSearchBar();

    Picker _picker = Picker(
        itemExtent: 40,
        adapter: PickerDataAdapter<String>(pickerdata: _translatedMenus),
        textAlign: TextAlign.center,
        hideHeader: true,
        backgroundColor: null,
        magnification: 1.1,
        textStyle: Theme.of(context).textTheme.bodyText1,
        onConfirm: (picker, value){
          _markers.clear();
          _mapController.getMarker(_menus[value.elementAt(0)]);
          String _toastString;
          switch(prefManager.read("localeCode")){
            case "ko_KR":
              _toastString = '${picker.getSelectedValues()[0]}(으)로 전환되었습니다.';
              break;
            case "en_US":
              _toastString = 'Changed to ${picker.getSelectedValues()[0]}.';
              break;
            case "zh":
              _toastString = '${picker.getSelectedValues()[0]}(으)로 전환되었습니다.';
              break;
          }
          Get.showSnackbar(GetBar(messageText: Text(_toastString), duration: Duration(seconds: 1),));
        }
    );
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.menu, color: Theme.of(context).textTheme.bodyText1.color,),
        backgroundColor: Theme.of(context).backgroundColor,
        onPressed: (){
          _picker.showDialog(context);
        },),
      body: Stack(
        children: [
          Container(
              padding: EdgeInsets.only(top: MediaQuery
                  .of(context)
                  .padding
                  .top),
              child: Container(child:
                  Obx(() {
                      return NaverMap(
                        markers: _mapController.selectedMarkers,
                        initialCameraPosition: CameraPosition(
                            target: LatLng(37.300153, 126.837759), zoom: 16),
                        mapType: MapType.Basic,
                        symbolScale: 0,
                        nightModeEnable: Get.isDarkMode,
                        onMapCreated: _onMapCreated,
                      );
                  }
              ))
          ),
          _floatingSearchBar
        ],
      ),
    );
  }

  void _onMapCreated(NaverMapController controller) {
    _mapController.naverMapController = controller;
  }


  Widget buildFloatingSearchBar() {

    return FloatingSearchBar(
        hint: "phone_hint_text".tr,
        backgroundColor: Get.context.theme.backgroundColor,
        scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
        transitionDuration: const Duration(milliseconds: 200),
        transitionCurve: Curves.easeInOut,
        physics: const BouncingScrollPhysics(),
        openAxisAlignment: 0.0,
        debounceDelay: const Duration(milliseconds: 100),
        controller: _floatingSearchBarController,
        onQueryChanged: (query) {
          _mapController.searchStore(query);
        },
        transition: CircularFloatingSearchBarTransition(),
        actions: [
          FloatingSearchBarAction(
            showIfOpened: false,
            child: CircularButton(
              icon: const Icon(Icons.place),
              onPressed: () {
                _mapController.naverMapController.moveCamera(CameraUpdate.scrollTo(LatLng(37.300153, 126.837759)));
              },
            ),
          ),
          FloatingSearchBarAction.searchToClear(
            showIfClosed: false,
          ),
        ],
        builder: (context, transition) {
          return Obx((){
                if(_mapController.searchResult.isEmpty){
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Material(
                      color: Theme.of(context).backgroundColor,
                      elevation: 4.0,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                              height: 75,
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Text("phone_not_found".tr, style: TextStyle(color: Theme.of(context).textTheme.bodyText1.color, fontSize: 20),),
                                ],
                              )
                          )],
                      ),
                    ),
                  );
                } else{
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Material(
                      color: Theme.of(context).backgroundColor,
                      elevation: 4.0,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: _mapController.searchResult.map((e) => InkWell(
                          onTap: () async {
                            _mapController.naverMapController.moveCamera(CameraUpdate.scrollTo(LatLng(e.latitude, e.longitude)));
                            _floatingSearchBar.controller.close();
                            _mapController.selectedMarkers.assignAll([Marker(markerId: "0", position: LatLng(e.latitude, e.longitude))]);
                          },
                          child: Container(
                            height: 75,
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("${e.name}-${e.menu}", style: Theme.of(context).textTheme.bodyText1, overflow: TextOverflow.ellipsis,),
                              ],
                            ),
                          ),
                        )).toList(),
                      ),
                    ),
                  );
                }
              });
        }
    );
  }
}