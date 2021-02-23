import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app_hyuabot_v2/Bloc/MapController.dart';
import 'package:flutter_app_hyuabot_v2/Config/GlobalVars.dart';
import 'package:flutter_app_hyuabot_v2/Model/Store.dart';
import 'package:flutter_material_pickers/helpers/show_scroll_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';
import 'package:easy_localization/easy_localization.dart';

class MapPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MapPageState();
}
class _MapPageState extends State<MapPage> {

  final _menus = ['korean', 'japanese', 'chinese', 'western', 'fast_food', 'chicken', 'pizza', 'meat', 'vietnamese', 'other_food', 'bakery', 'cafe', 'pub'];
  List<String> _translatedMenus;

  MapController _mapController;
  NaverMapController _naverMapController;
  List<Marker> _markers = [];
  Widget _map;
  bool _isInitial = true;
  FloatingSearchBar _floatingSearchBar;
  FloatingSearchBarController _floatingSearchBarController = FloatingSearchBarController();

  @override
  void initState() {
    super.initState();
    analytics.setCurrentScreen(screenName: "/map");
  }

  @override
  Widget build(BuildContext context) {
    if(_isInitial){
      Fluttertoast.showToast(
          msg: "map_start_dialog".tr());
      _isInitial = false;
    }
    _mapController = MapController(context);
    _mapController.loadDatabase();
    _translatedMenus = _menus.map((e) => e.tr()).toList();
    String _selectedCat = _translatedMenus[0];
    _map = _naverMap(context);
    _floatingSearchBar = buildFloatingSearchBar();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.category, color: Colors.white,),
        backgroundColor: Color(0xff2db400),
        onPressed: () {
          showMaterialScrollPicker(
            context: context,
            title: "map_picker_title".tr(),
            items: _translatedMenus,
            selectedItem: _translatedMenus[0],
            onChanged: (value) {
              _selectedCat = value;
            },
            onConfirmed: () {
              _markers.clear();
              _mapController.getMarker(
                  _menus[_translatedMenus.indexOf(_selectedCat)]);
              String _toastString;
              switch (prefManager.getString("localeCode")) {
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
              Fluttertoast.showToast(msg: _toastString);
            },
          );
      }),
      body: Stack(
        children: [
          Container(
              padding: EdgeInsets.only(top: MediaQuery
                  .of(context)
                  .padding
                  .top),
              child: Container(child: _map)
          ),
          _floatingSearchBar
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  _naverMap(BuildContext context) {
    return StreamBuilder<List<Marker>>(
        stream: _mapController.selectedMarkers,
        builder: (context, snapshot) {
          if(snapshot.hasError || !snapshot.hasData){
            _markers.clear();
          } else {
            _markers = snapshot.data;
          }
          return NaverMap(
            markers: _markers,
            initialCameraPosition: CameraPosition(
                target: LatLng(37.300153, 126.837759), zoom: 17.5),
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
    _mapController.naverMapController = controller;
    _naverMapController = controller;
  }


  Widget buildFloatingSearchBar() {
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return FloatingSearchBar(
        hint: "phone_hint_text".tr(),
        backgroundColor: Theme.of(context).backgroundColor,
        scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
        transitionDuration: const Duration(milliseconds: 200),
        transitionCurve: Curves.easeInOut,
        physics: const BouncingScrollPhysics(),
        axisAlignment: isPortrait ? 0.0 : -1.0,
        openAxisAlignment: 0.0,
        maxWidth: isPortrait ? 600 : 500,
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
          return StreamBuilder<List<StoreSearchInfo>>(
              stream: _mapController.searchResult,
              builder: (context, snapshot){
                if(snapshot.hasError || !snapshot.hasData || snapshot.data.isEmpty){
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
                            _floatingSearchBar.controller.close();
                            _mapController.selectMarker([Marker(markerId: e.name, position: LatLng(e.latitude, e.longitude), infoWindow: e.name)]);
                            _naverMapController.moveCamera(CameraUpdate.scrollTo(LatLng(e.latitude, e.longitude)));
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
            });
        }
    );
  }
}