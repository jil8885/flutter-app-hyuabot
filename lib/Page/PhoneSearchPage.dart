import 'package:flutter/material.dart';
import 'package:flutter_app_hyuabot_v2/Bloc/PhoneSearchController.dart';
import 'package:flutter_app_hyuabot_v2/Config/GlobalVars.dart';
import 'package:flutter_app_hyuabot_v2/Model/Phone.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;


class PhoneSearchPage extends StatelessWidget {
  final List<String> tabList = ["phone_tab_inschool", "phone_tab_outschool"];
  final _inSchoolTextEditor = TextEditingController();
  final _outSchoolTextEditor = TextEditingController();
  final _inSchoolSearchController = Get.put(InSchoolPhoneSearchController());
  final _outSchoolSearchController = Get.put(OutSchoolPhoneSearchController());

  @override
  Widget build(BuildContext context) {
    analytics.setCurrentScreen(screenName: "/contacts");
    final double height = MediaQuery.of(context).padding.top;

    _inSchoolTextEditor.addListener(() {
      _inSchoolSearchController.search(_inSchoolTextEditor.value.text.trim());
    });
    _outSchoolTextEditor.addListener(() {
      _outSchoolSearchController.search(_outSchoolTextEditor.value.text.trim());
    });

    final Widget _searchTabInSchool = Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        TextField(
          controller: _inSchoolTextEditor,
          keyboardType: TextInputType.text,

          decoration: InputDecoration(
          hintText: "phone_hint_text".tr,
          labelText: "phone_label_text".tr,
          helperText: "phone_helper_text".tr,
          suffixIcon: Icon(Icons.search_rounded)
          )
        ),
        Obx((){
            if(_inSchoolSearchController.isLoading.value){
              return CircularProgressIndicator();
            } else if(_inSchoolSearchController.searchResult.isEmpty){
              return Center(child: Text("phone_not_found".tr, style: TextStyle(color: Theme.of(context).textTheme.bodyText1.color),),);
            } else {
              return Expanded(
                child: ListView.builder(
                    itemCount: _inSchoolSearchController.searchResult.length,
                    itemBuilder: (context, index){
                      return GestureDetector(
                        onTap: (){UrlLauncher.launch("tel://${_inSchoolSearchController.searchResult[index].number}");},
                        child: Card(
                          color: Theme.of(context).backgroundColor == Colors.white ? Theme.of(context).accentColor : Colors.black,
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  _inSchoolSearchController.searchResult[index].name,
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.white,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 15,),
                                Text(
                                  _inSchoolSearchController.searchResult[index].number,
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                ),
              );
            }
          }
        )
      ],
    );


    final Widget _searchTabOutSchool = Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        TextField(
            controller: _outSchoolTextEditor,
            keyboardType: TextInputType.text,

            decoration: InputDecoration(
                hintText: "phone_hint_text".tr,
                labelText: "phone_label_text".tr,
                helperText: "phone_helper_text".tr,
                suffixIcon: Icon(Icons.search_rounded)
            )
        ),
        Obx((){
              if(_outSchoolSearchController.isLoading.value){
                return CircularProgressIndicator();
              } else if(_outSchoolSearchController.searchResult.isEmpty){
                return Center(child: Text("phone_not_found".tr, style: TextStyle(color: Theme.of(context).textTheme.bodyText1.color),),);
              } else {
                return Expanded(
                  child: ListView.builder(
                      itemCount: _outSchoolSearchController.searchResult.length,
                      itemBuilder: (context, index){
                        return GestureDetector(
                          onTap: (){UrlLauncher.launch("tel://${_outSchoolSearchController.searchResult[index].number}");},
                          child: Card(
                            color: Theme.of(context).backgroundColor == Colors.white ? Theme.of(context).accentColor : Colors.black,
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    _outSchoolSearchController.searchResult[index].name,
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.white,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 15,),
                                  Text(
                                    _outSchoolSearchController.searchResult[index].number,
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                  ),
                );
              }
            }
        )
      ],
    );

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: height, horizontal: height/2),
        child: DefaultTabController(
          length: 2,
            child: Column(
            children: [
              TabBar(tabs: [
                Tab(child: Text("phone_tab_inschool".tr, style: Theme.of(context).textTheme.bodyText1,),),
                Tab(child: Text("phone_tab_outschool".tr, style: Theme.of(context).textTheme.bodyText1,),),
              ],),
              Expanded(
                child: TabBarView(
                  children: [
                    _searchTabInSchool,
                    _searchTabOutSchool
                  ],
                ),
              )
          ])
        )
      ),
    );
  }
}