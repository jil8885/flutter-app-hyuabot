import 'package:flutter/material.dart';
import 'package:flutter_app_hyuabot_v2/Bloc/PhoneSearchController.dart';
import 'package:flutter_app_hyuabot_v2/Config/GlobalVars.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;


class PhoneSearchPage extends StatelessWidget {
  final List<String> tabList = ["phone_tab_inschool", "phone_tab_outschool"];
  final _inSchoolTextEditor = TextEditingController();
  final _outSchoolTextEditor = TextEditingController();

  @override
  Widget build(BuildContext context) {
    analytics.setCurrentScreen(screenName: "/contacts");
    final double height = MediaQuery.of(context).padding.top;

    _inSchoolTextEditor.addListener(() {
      inSchoolPhoneSearchController.search(_inSchoolTextEditor.value.text.trim());
    });
    _outSchoolTextEditor.addListener(() {
      inSchoolPhoneSearchController.search(_outSchoolTextEditor.value.text.trim());
    });

    final Widget _searchTabInSchool = Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        TextField(
          controller: _inSchoolTextEditor,
          keyboardType: TextInputType.text,

          decoration: InputDecoration(
          hintText: "phone_hint_text".tr(),
          labelText: "phone_label_text".tr(),
          helperText: "phone_helper_text".tr(),
          suffixIcon: Icon(Icons.search_rounded)
          )
        ),
        StreamBuilder(
          stream: inSchoolPhoneSearchController.searchResult,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if(snapshot.hasError || !snapshot.hasData){
              return CircularProgressIndicator();
            } else if(snapshot.data.isEmpty){
              return Center(child: Text("phone_not_found".tr(), style: TextStyle(color: Theme.of(context).textTheme.bodyText2.color),),);
            } else {
              return Expanded(
                child: ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index){
                      return GestureDetector(
                        onTap: (){UrlLauncher.launch("tel://${snapshot.data[index].number}");},
                        child: Card(
                          color: Theme.of(context).backgroundColor == Colors.white ? Theme.of(context).accentColor : Colors.black,
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  snapshot.data[index].name,
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.white,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 15,),
                                Text(
                                  snapshot.data[index].number,
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
          },
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
                hintText: "phone_hint_text".tr(),
                labelText: "phone_label_text".tr(),
                helperText: "phone_helper_text".tr(),
                suffixIcon: Icon(Icons.search_rounded)
            )
        ),
        StreamBuilder(
          stream: outSchoolPhoneSearchController.searchResult,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if(snapshot.hasError || !snapshot.hasData){
              return CircularProgressIndicator();
            } else if(snapshot.data.isEmpty){
              return Center(child: Text("phone_not_found".tr(), style: TextStyle(color: Theme.of(context).textTheme.bodyText2.color),),);
            } else {
              return Expanded(
                child: ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index){
                      return GestureDetector(
                        onTap: (){UrlLauncher.launch("tel://${snapshot.data[index].number}");},
                        child: Card(
                          color: Theme.of(context).backgroundColor == Colors.white ? Theme.of(context).accentColor : Colors.black,
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  snapshot.data[index].name,
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.white,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 15,),
                                Text(
                                  snapshot.data[index].number,
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
          },
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
                Tab(child: Text("phone_tab_inschool".tr(), style: Theme.of(context).textTheme.bodyText2,),),
                Tab(child: Text("phone_tab_outschool".tr(), style: Theme.of(context).textTheme.bodyText2,),),
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