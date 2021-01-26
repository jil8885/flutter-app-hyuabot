import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app_hyuabot_v2/Bloc/DatabaseController.dart';
import 'package:flutter_app_hyuabot_v2/Bloc/MapController.dart';
import 'package:flutter_app_hyuabot_v2/Config/GlobalVars.dart';
import 'package:get/get.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';
import 'package:flutter_picker/flutter_picker.dart';

class MapPage extends StatelessWidget {
  final _menus = ['korean', 'japanese', 'chinese', 'western', 'fast_food', 'chicken', 'pizza', 'meat', 'vietnamese', 'other_food', 'bakery', 'cafe', 'pub'];

  Widget _map;
  FloatingSearchBar _floatingSearchBar;
  FloatingSearchBarController _floatingSearchBarController = FloatingSearchBarController();
  List<Marker> _markers = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  _getMarkers(String category) async {
  }

  _onMarkerTap(Marker marker, Map<String, int> iconSize){
    mapController.moveCamera(CameraUpdate.scrollTo(LatLng(marker.position.latitude, marker.position.longitude)));
  }

  @override
  Widget build(BuildContext context) {
    analytics.setCurrentScreen(screenName: "/map");
    Get.showSnackbar(GetBar(messageText: Text("map_start_dialog".tr),));
    List<String> _translatedMenus = _menus.map((e) => e.tr).toList();

    _map = _naverMap(context, "");
    _floatingSearchBar = buildFloatingSearchBar();

    Picker _picker = Picker(itemExtent: 40, adapter: PickerDataAdapter<String>(pickerdata: _translatedMenus), textAlign: TextAlign.center, hideHeader: true, backgroundColor: null, magnification: 1.1, textStyle: Theme.of(context).textTheme.bodyText1,
        onConfirm: (picker, value){
          _markers.clear();
          _getMarkers(_menus[value.elementAt(0)]);
          String _toastString;
          switch(prefManager.getString("localeCode")){
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
          Get.showSnackbar(GetBar(messageText: Text(_toastString),));
        }
    );
    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.menu, color: Theme.of(context).textTheme.bodyText1.color,),
        backgroundColor: Theme.of(context).backgroundColor,
        onPressed: (){
          _picker.showDialog(context);
        },),
      body: Stack(
        children: [
          Container(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: Container(child: _map)
          ),
          _floatingSearchBar
        ],
      ),
    );
  }

  _naverMap(BuildContext context, String catString) {
    return GetBuilder<MapController>(
      builder: (controller) {
        int index = 0;
        String assetName = "restaurant";
        if(catString == "pub"){
          assetName = "pub";
        } else if(catString == "cafe"){
          assetName = "cafe";
        }
        OverlayImage image;
        OverlayImage.fromAssetImage(assetName: "assets/images/$assetName.png", context: Get.context).then((value){image = value;});
        for(Map marker in controller.getMarkers(catString)){
          _markers.add(
            Marker(
              markerId: '$index',
              position: LatLng(double.parse(marker['latitude'].toString()), double.parse(marker['longitude'].toString())),
              icon: image,
              width: 20,
              height: 20,
              captionText: catString,
              infoWindow: controller.getStoreList(catString, marker),
              onMarkerTab: _onMarkerTap
            )
          );
          index++;
        }
        return NaverMap(
          markers: _markers,
          initialCameraPosition: CameraPosition(
              target: LatLng(37.300153, 126.837759), zoom: 16),
          mapType: MapType.Basic,
          symbolScale: 0,
          nightModeEnable: Get.isDarkMode,
          onMapCreated: _onMapCreated,
        );
      }
    );
  }

  void _onMapCreated(NaverMapController controller) {
    mapController = controller;
  }


  Widget buildFloatingSearchBar() {
    return FloatingSearchBar(
      hint: "phone_hint_text".tr,
      backgroundColor: Get.theme.backgroundColor,
      scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
      transitionDuration: const Duration(milliseconds: 200),
      transitionCurve: Curves.easeInOut,
      physics: const BouncingScrollPhysics(),
      openAxisAlignment: 0.0,
      debounceDelay: const Duration(milliseconds: 100),
      controller: _floatingSearchBarController,
      onQueryChanged: (query) {
        Get.find<MapController>().searchStore(query);
      },
      transition: CircularFloatingSearchBarTransition(),
      actions: [
        FloatingSearchBarAction(
          showIfOpened: false,
          child: CircularButton(
            icon: const Icon(Icons.place),
            onPressed: () {
              mapController.moveCamera(CameraUpdate.scrollTo(LatLng(37.300153, 126.837759)));
            },
          ),
        ),
        FloatingSearchBarAction.searchToClear(
          showIfClosed: false,
        ),
      ],
      builder: (context, transition) {
          return GetBuilder<MapController>(
            builder: (controller){
                return ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Material(
                    color: Theme.of(context).backgroundColor,
                    elevation: 4.0,
                    child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: controller.searchResult.map((e) => InkWell(
                    onTap: () async {
                      String assetName = "restaurant";
                      OverlayImage image = await OverlayImage.fromAssetImage(assetName: "assets/images/$assetName.png", context: context);
                      mapController.moveCamera(CameraUpdate.scrollTo(LatLng(e.latitude, e.longitude)));
                      _floatingSearchBar.controller.close();
                      _markers.clear();
                      _markers.add(Marker(markerId: e.name, position: LatLng(e.latitude, e.longitude), infoWindow: e.name, icon: image, width: 20, height: 20,));
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
          );
        }
      );
    }
}
