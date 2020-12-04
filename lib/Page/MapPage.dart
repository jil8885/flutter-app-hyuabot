import 'dart:async';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';


class MapPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MapPageState();
}
class _MapPageState extends State<MapPage>{
  List<Marker> _markers = [];
  Completer<NaverMapController> _controller = Completer();

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    final double _height = MediaQuery.of(context).size.height;
    return FutureBuilder(
      future: _naverMap(),
      builder: (context, snapshot){
        if(snapshot.hasData){
          return Scaffold(
            body: Container(
                padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                child: Container(child: Stack(children: [
                  snapshot.data,
                  
                ],))
            ),
          );
        }else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  _naverMap() async {
    return NaverMap(
      onMapCreated: _onMapCreated,
      onMapTap: _onMapTab,
      markers: _markers,
      initialCameraPosition: CameraPosition(target: LatLng(37.300153, 126.837759), zoom: 16 ),
      mapType: MapType.Basic,
      symbolScale: 0,
      nightModeEnable: await AdaptiveTheme.getThemeMode() == AdaptiveThemeMode.dark,
    );
  }

  _onMapCreated(NaverMapController controller){
    _controller.complete(controller);
  }

  _onMapTab(LatLng latLng){

  }

  _onMarkerTap(Marker marker, Map<String, int> iconSize){

  }

}