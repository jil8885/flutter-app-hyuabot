import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app_hyuabot_v2/Bloc/MapController.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:get/get.dart';

class MapPage extends StatelessWidget {
  final _menus = ['korean', 'japanese', 'chinese', 'western', 'fast_food', 'chicken', 'pizza', 'meat', 'vietnamese', 'other_food', 'bakery', 'cafe', 'pub'];
  final _cameraPosition = CameraPosition(target: LatLng(37.300153, 126.837759), zoom: 19);
  final _searchController = FloatingSearchBarController();
  final _controller = Get.put(MapController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.menu, color: Theme.of(context).textTheme.bodyText1.color,),
        backgroundColor: Theme.of(context).backgroundColor,
        onPressed: (){

        },
      ),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _cameraPosition,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
          ),
          FloatingSearchBar(
            hint: "phone_hint_text".tr,
            backgroundColor: Get.theme.backgroundColor,
            scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
            transitionDuration: const Duration(milliseconds: 200),
            transitionCurve: Curves.easeInOut,
            physics: const BouncingScrollPhysics(),
            openAxisAlignment: 0.0,
            debounceDelay: const Duration(milliseconds: 100),
            controller: _searchController,
            onQueryChanged: (query){
              _controller.searchStore(query);
            },
            transition: CircularFloatingSearchBarTransition(),
            actions: [
              FloatingSearchBarAction.searchToClear(
                showIfClosed: false,
              ),
            ],
            builder: (context, _) {
              return Obx(() {
                var storeList = _controller.searchResult;
                print(storeList);
                if(_controller.isLoading.value){
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Material(
                      color: Theme
                          .of(context)
                          .backgroundColor,
                      elevation: 4.0,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                              height: 75,
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceAround,
                                children: [
                                  CircularProgressIndicator()
                                ],
                              )
                          )
                        ],
                      ),
                    ),
                  );
                }
                else if (storeList.isEmpty) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Material(
                      color: Theme
                          .of(context)
                          .backgroundColor,
                      elevation: 4.0,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                              height: 75,
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceAround,
                                children: [
                                  Text("phone_not_found".tr,
                                    style: TextStyle(color: Theme
                                        .of(context)
                                        .textTheme
                                        .bodyText1
                                        .color, fontSize: 20),),
                                ],
                              )
                          )
                        ],
                      ),
                    ),
                  );
                } else {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Material(
                      color: Theme
                          .of(context)
                          .backgroundColor,
                      elevation: 4.0,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: storeList.map((e) =>
                            InkWell(
                              onTap: () async {

                              },
                              child: Container(
                                  height: 75,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("${e.name}-${e.menu}", style: Theme
                                          .of(context)
                                          .textTheme
                                          .bodyText1,
                                        overflow: TextOverflow.ellipsis,),
                                    ],
                                  )),
                            )).toList(),
                      ),
                    ),
                  );
                }
              });
            }
          )
        ],
      ),
    );
  }
}
