import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app_hyuabot_v2/Bloc/DatabaseController.dart';
import 'package:flutter_app_hyuabot_v2/Config/GlobalVars.dart';
import 'package:flutter_app_hyuabot_v2/Config/Localization.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';


class MapPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MapPageState();
}
class _MapPageState extends State<MapPage> {
  final _menus = [
    'korean',
    'japanese',
    'chinese',
    'western',
    'fast_food',
    'chicken',
    'pizza',
    'meat',
    'vietnamese',
    'other_food',
    'bakery',
    'cafe',
    'pub'
  ];
  List<String> _translatedMenus;
  String _selectedValue;

  DataBaseController _dataBaseController;
  List<Marker> _markers = [];
  BuildContext _context;
  NaverMap _map;

  @override
  void initState() {
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
    Fluttertoast.showToast(
        msg: TranslationManager.of(context).trans("map_start_dialog"));
    _dataBaseController = DataBaseController(context);
    _dataBaseController.init().whenComplete(() {});
    _context = context;
    _translatedMenus =
        _menus.map((e) => TranslationManager.of(context).trans(e)).toList();
    _selectedValue = _translatedMenus[0];
    _map = _naverMap(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.category, color: Colors.white,),
        backgroundColor: Color(0xff2db400),
        onPressed: _menuButtonPressed,),
      body: Container(
          padding: EdgeInsets.only(top: MediaQuery
              .of(context)
              .padding
              .top),
          child: Container(child: _map)
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  _naverMap(BuildContext context) {
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

  void _onMapCreated(NaverMapController controller) {
    mapController = controller;
  }

  _menuButtonPressed() {
    showMaterialScrollPicker(
        context: _context,
        title: "Category",
        backgroundColor: Colors.grey,
        buttonTextColor: Theme
            .of(_context)
            .textTheme
            .bodyText2
            .color,
        items: _translatedMenus,
        selectedItem: _selectedValue,
        onChanged: (value) {
          _selectedValue = _menus[_translatedMenus.indexOf(value)];
          _getMarkers(_selectedValue);
        }
    );
  }
}
