import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app_hyuabot_v2/Bloc/MapController.dart';
import 'package:flutter_app_hyuabot_v2/Config/GlobalVars.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';
import 'package:easy_localization/easy_localization.dart';

class MapPage extends StatelessWidget {
  final _menus = ['korean', 'japanese', 'chinese', 'western', 'fast_food', 'chicken', 'pizza', 'meat', 'vietnamese', 'other_food', 'bakery', 'cafe', 'pub'];
  bool _isInit = false;
  List<String> _translatedMenus;


  List<Marker> _markers = [];
  FloatingSearchBar _floatingSearchBar;
  FloatingSearchBarController _floatingSearchBarController = FloatingSearchBarController();
  OverlayImage image;
  MapController _mapController;

  @override
  Widget build(BuildContext context) {
    _mapController = MapController(context);
    if(!_isInit){
      Fluttertoast.showToast(msg: "map_start_dialog".tr());
      _isInit = true;
    }
    analytics.setCurrentScreen(screenName: "/map");
    _translatedMenus = _menus.map((e) => e.tr()).toList();
    _floatingSearchBar = buildFloatingSearchBar(context);
    String _selectedCat = _translatedMenus[0];

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.menu, color: Theme.of(context).textTheme.bodyText2.color,),
        backgroundColor: Theme.of(context).backgroundColor,
        onPressed: (){
          showMaterialScrollPicker(
            context: context,
            title: "map_picker_title".tr(),
            items: _translatedMenus,
            selectedItem: _translatedMenus[0],
            onChanged: (value){_selectedCat = value;},
            onConfirmed: (){
              _markers.clear();
              _mapController.getMarker(_menus[_translatedMenus.indexOf(_selectedCat)]);
              String _toastString;
              switch(prefManager.getString("localeCode")){
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
              Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text(_toastString, style: TextStyle(color: Theme.of(context).backgroundColor == Colors.black ?Colors.white:Colors.black), textAlign: TextAlign.center,),
                    duration: Duration(seconds: 2),
                    backgroundColor: Theme.of(context).backgroundColor,
              ));
            }
          );
        },),
      body: Stack(
        children: [
          Container(
              padding: EdgeInsets.only(top: MediaQuery
                  .of(context)
                  .padding
                  .top),
              child: Container(child:
                StreamBuilder(
                  stream: _mapController.markers,
                  builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    return NaverMap(
                      markers: snapshot.data,
                      initialCameraPosition: CameraPosition(
                          target: LatLng(37.300153, 126.837759), zoom: 16),
                      mapType: MapType.Basic,
                      symbolScale: 0,
                      nightModeEnable: Theme.of(context).backgroundColor == Colors.black,
                      onMapCreated: _onMapCreated,
                    );
                  },
                )
            )
          ),
          _floatingSearchBar
        ],
      ),
    );
  }

  void _onMapCreated(NaverMapController controller) {
    _mapController.naverMapController = controller;
  }


  Widget buildFloatingSearchBar(BuildContext context) {

    return FloatingSearchBar(
        hint: "phone_hint_text".tr(),
        backgroundColor: Theme.of(context).backgroundColor,
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
          return StreamBuilder(
            stream: _mapController.searchResult,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if(snapshot.data.isEmpty){
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
                                Text("phone_not_found".tr(), style: TextStyle(color: Theme.of(context).textTheme.bodyText2.color, fontSize: 20),),
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
                      children: snapshot.data.map((e) => InkWell(
                        onTap: () async {
                          _mapController.naverMapController.moveCamera(CameraUpdate.scrollTo(LatLng(e.latitude, e.longitude)));
                          _floatingSearchBar.controller.close();
                          _mapController.selectMarker([Marker(markerId: "0", position: LatLng(e.latitude, e.longitude))]);
                        },
                        child: Container(
                          height: 75,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("${e.name}-${e.menu}", style: Theme.of(context).textTheme.bodyText2, overflow: TextOverflow.ellipsis,),
                            ],
                          ),
                        ),
                      )).toList(),
                    ),
                  ),
                );
              }
            },);
        }
    );
  }
}