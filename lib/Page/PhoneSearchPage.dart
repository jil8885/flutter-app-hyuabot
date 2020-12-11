import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app_hyuabot_v2/Bloc/DatabaseController.dart';
import 'package:flutter_app_hyuabot_v2/Config/Localization.dart';
import 'package:flutter_point_tab_bar/pointTabBar.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;


class PhoneSearchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PhoneSearchPageState();

}
class _PhoneSearchPageState extends State<PhoneSearchPage> with SingleTickerProviderStateMixin{
  TabController _controller;
  DataBaseController _dataBaseController;
  TextEditingController _textEditingController;

  List<String> tabList = ["phone_tab_inschool", "phone_tab_outschool"];
  databaseInit(){
    _dataBaseController.init();
  }

  @override
  void initState() {
    _controller = TabController(length: 2, vsync: this);
    _textEditingController = TextEditingController();
    _dataBaseController = DataBaseController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _dataBaseController.init().whenComplete(() {_dataBaseController.fetchInSchoolList();});
    final double height = MediaQuery.of(context).padding.top;
    _controller.addListener(() {
      switch(_controller.index){
        case 0:
          _textEditingController.clear();
          _dataBaseController.fetchInSchoolList();
          break;
        case 1:
          _textEditingController.clear();
          _dataBaseController.fetchOutSchoolList();
          break;
      }
    });

    _textEditingController.addListener(() {
      if(_controller.index == 0){
        _dataBaseController.fetchInSchoolList(_textEditingController.value.text);
      } else {
        _dataBaseController.fetchOutSchoolList(_textEditingController.value.text);

      }
    });

    Widget _searchKeywordInput = TextField(
      controller: _textEditingController,
      keyboardType: TextInputType.text,

      decoration: InputDecoration(
        hintText: TranslationManager.of(context).trans("phone_hint_text"),
        labelText: TranslationManager.of(context).trans("phone_label_text"),
        helperText: TranslationManager.of(context).trans("phone_helper_text"),
        suffixIcon: Icon(Icons.search_rounded)
      ),
    );

    Widget _searchTabInSchool = Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(height: 15,),
        StreamBuilder<List<PhoneNum>>(
          stream: _dataBaseController.searchPhoneResultInSchool,
          builder: (context, snapshot){
            if(snapshot.hasError || !snapshot.hasData){
              return CircularProgressIndicator();
            } else if(snapshot.data.isEmpty){
              return Center(child: Text(TranslationManager.of(context).trans("phone_not_found"), style: TextStyle(color: Theme.of(context).textTheme.bodyText1.color),),);
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
          }
        )
      ],
    );

    Widget _searchTabOutSchool = Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(height: 15,),
        StreamBuilder<List<PhoneNum>>(
            stream: _dataBaseController.searchPhoneResultOutSchool,
            builder: (context, snapshot){
              if(snapshot.hasError || !snapshot.hasData){
                return CircularProgressIndicator();
              } else if(snapshot.data.isEmpty){
                return Center(child: Text(TranslationManager.of(context).trans("phone_not_found"), style: TextStyle(color: Theme.of(context).textTheme.bodyText1.color),),);
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
            }
        )
      ],
    );

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(height),
        child: Column(
          children: [
            TabBar(
              tabs: tabList.map((e) => Tab(child: Text(TranslationManager.of(context).trans(e), style: TextStyle(color: Theme.of(context).backgroundColor == Colors.white ? Colors.black : Colors.white),),)).toList(),
              controller: _controller,
              indicator: PointTabIndicator(position: PointTabIndicatorPosition.bottom, color: Theme.of(context).backgroundColor == Colors.white ? Colors.black : Colors.white, insets: EdgeInsets.only(bottom: 6)),
            ),
            _searchKeywordInput,
            Expanded(child: TabBarView(controller: _controller, children: [_searchTabInSchool, _searchTabOutSchool],))
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _textEditingController.dispose();
    _dataBaseController.dispose();
    super.dispose();
  }
}