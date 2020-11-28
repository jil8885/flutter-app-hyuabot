import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutter_app_hyuabot_v2/Page/SettingPage.dart';

class HomePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{
  bool _isExpanded = false;

  void _expand() {
    setState(() {
      _isExpanded ? _isExpanded = false : _isExpanded = true;
    });
  }

  Widget _menuButton(double width, double height, String assetName, String menuName, Widget newPage){
    return Column(
      children: [
        GestureDetector(
          onTap: (){Get.to(newPage);},
          child: Image.asset(null, width: width, height: height,),
        ),
        SizedBox(height: 5,),
        Flexible(child: Text(menuName, style: TextStyle(height: 13),))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // 화면 너비, 크기 조정
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;

    Widget _menuWidget = Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: AnimatedCrossFade(
        crossFadeState: _isExpanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
        duration: kThemeAnimationDuration,
        firstChild: GridView.count(
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 4,
          shrinkWrap: true,
          children: [
            _menuButton(_width / 12, _width / 12, null, "셔틀버스", Container()),
            _menuButton(_width / 12, _width / 12, null, "노선버스", Container()),
            _menuButton(_width / 12, _width / 12, null, "지하철", Container()),
            _menuButton(_width / 12, _width / 12, null, "학식", Container()),
            _menuButton(_width / 12, _width / 12, null, "열람실", Container()),
            _menuButton(_width / 12, _width / 12, null, "전화부", Container()),
            // _menuButton(_width / 12, _width / 12, null, "셔틀", Container()),
            // _menuButton(_width / 12, _width / 12, null, "셔틀", Container()),
          ],
        ),
        secondChild: GridView.count(
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 4,
          shrinkWrap: true,
          children: [
            _menuButton(_width / 12, _width / 12, null, "셔틀버스", Container()),
            _menuButton(_width / 12, _width / 12, null, "노선버스", Container()),
            _menuButton(_width / 12, _width / 12, null, "지하철", Container()),
            _menuButton(_width / 12, _width / 12, null, "학식", Container()),
          ],
        ),
      ),
    );

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        elevation: 3,
        onPressed: () => Get.to(SettingPage()),
        label: Text("설정", textAlign: TextAlign.center, style: TextStyle(color:Colors.white),),
        icon: Icon(Icons.settings),
        backgroundColor: Theme.of(context).accentColor,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(),
      body: Container(
        height: _height,
        width: _width,
        child: Column(
          children: [
            // clipShape(),
            Container(
              margin: EdgeInsets.only(left: 30, right: 30, top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('메뉴',
                      style: TextStyle(
                          fontSize: 16)),
                  GestureDetector(
                      onTap: _expand,
                      child: Text(
                        _isExpanded ? "Show less" : "Show all",
                        style: TextStyle(
                          color: Colors.orange[200],
                        ),
                      )),
                  IconButton(icon: _isExpanded? Icon(Icons.arrow_drop_up, color: Colors.orange[200],) : Icon(Icons.arrow_drop_down, color: Colors.orange[200],), onPressed: _expand)
                ],
              ),
            ),
            _menuWidget,
            Divider(),
            Container(
              margin: EdgeInsets.only(left: 30, right: 30, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Trending",
                      style: TextStyle(
                          fontSize: 16)),
                  GestureDetector(
                      onTap: () {
                        // Navigator.of(context).pushNamed(TRENDING_UI);
                        print('Showing all');
                      },
                      child: Text(
                        'Show all',
                        style: TextStyle(
                          color: Colors.orange[300],
                        ),
                      ))
                ],
              ),
            ),
            // trendingProducts(),
            Divider(),
            Container(
              margin: EdgeInsets.only(left: 30, right: 30, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Recommendations",
                      style: TextStyle(
                          fontSize: 16)),
                  GestureDetector(
                      onTap: () {
                        //Navigator.of(context).pushNamed(RECOMMEND_UI);
                        print('Showing all');
                      },
                      child: Text(
                        'Show all',
                        style: TextStyle(
                          color: Colors.orange[300],
                        ),
                      ))
                ],
              ),
            ),
            // recommendations(),
            Divider(),
            Container(
              margin: EdgeInsets.only(left: 30, right: 30, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Today's Deals",
                      style: TextStyle(
                          fontSize: 16)),
                  GestureDetector(
                      onTap: () {
                        //Navigator.of(context).pushNamed(DEALS_UI);
                        print('Showing all');
                      },
                      child: Text(
                        'Show all',
                        style: TextStyle(
                          color: Colors.orange[300],
                        ),
                      ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}