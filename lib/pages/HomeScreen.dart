import 'package:chatbot/model/Bus.dart';
import 'package:chatbot/networking/GetBus.dart';
import 'package:chatbot/networking/GetShuttle.dart';
import 'package:chatbot/ui/BusLine.dart';
import 'package:chatbot/ui/ShuttleLine.dart';
import 'package:chatbot/ui/MetroLine.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'file:///D:/Jeongin/Projects/flutter-app-hyuabot/lib/config/style.dart';
import 'package:chatbot/ui/ChatMessage.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ChatMessage> _messages = [ChatMessage(text: "안녕하냥~내가 너를 도와줄게!")];

  // 버튼 항목 선언
  int _selected = -1;
  int _menuSelected = 0;
  List<String> _buttonName = ["교통", "학식", "도서", "전화"];
  List<String> _buttonTransportName = ["셔틀", "전철", "노선버스"];
  List<String> _buttonFoodName = ["학생식당", "교직원식당", "푸드코트", "창업보육센터", "창의인재원식당"];
  List<String> _buttonLibraryName = ["도서 검색", "열람실 잔여좌석"];
  List<List<String>> _buttonAsset = [
    ["images/icon-bus-active.png", "images/icon-bus.png"],
    ["images/icon-food-active.png", "images/icon-food.png"],
    ["images/icon-book-active.png", "images/icon-book.png"],
    ["images/icon-phone-active.png", "images/icon-phone.png"]
  ];

  var _logoImage = Image.asset('images/logo-default.png');

  // 홈화면 상태 빌드 함수
  @override
  Widget build(BuildContext context) {
    List _menus = [
      Row(
        children: _buildButtons(),
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      ),
      Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              setState(() {
                _menuSelected = 0;
                _messages.removeLast();
              });
            },
          ),
          Flexible(
            child: Row(
              children: _buildTransportButtons(),
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
            ),
          ),
        ],
      ),
      Row(children: [
        IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            setState(() {
              _menuSelected = 0;
              _messages.removeLast();
            });
          },
        ),
        Flexible(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _buildFoodButtons(),
            ),
          ),
        ),
      ],),
      Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              setState(() {
                _menuSelected = 0;
                _messages.removeLast();
              });
            },
          ),
          Flexible(
            child: Row(
              children: _buildLibraryButtons(),
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            ),
          ),
        ],
      )
    ];
    // 전체 스크린
    return Scaffold(
        appBar: EmptyAppBar(),
        body: WillPopScope(
          child: Container(
              color: Color.fromRGBO(239, 244, 244, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                // 로고 부분
                Container(
                  margin: const EdgeInsets.only(top: 10, left: 30, right: 30),
                  child: _logoImage,
                ),
                // 메인 화면
                Expanded(
                  child: Container(
                    color: Color.fromRGBO(239, 244, 244, 0),
                    child: ListView.builder(
                      itemBuilder: (_, int index) => _messages[index],
                      itemCount: _messages.length,
                      padding: EdgeInsets.all(8.0),
                    ),
                  ),
                ),
                Padding(
                  child: _menus[_menuSelected],
                  padding: EdgeInsets.only(bottom: 10, left: 7.5, right: 7.5),
                ),
                // 메세지 전송 버튼
              ])),
          onWillPop: () {},
        ));
  }

  List<Widget> _buildButtons() {
    List<Widget> _listButtons = List.generate(_buttonName.length, (index) {
      return SizedBox(
        width: 88,
        child: RaisedButton(
          onPressed: () {
            setState(() {
              _selected = index;
              if (_messages.length > 1) {
                _messages = [ChatMessage(text: "안녕하냥~내가 너를 도와줄게!")];
              }
              switch (index) {
                case 0:
                  _messages.add(ChatMessage(text: "원하는 교통수단을 골라달라냥!"));
                  _menuSelected = 1;
                  break;
                case 1:
                  _messages.add(ChatMessage(text: "메뉴를 알고 싶은 식당을 골라달라냥!"));
                  _menuSelected = 2;
                  break;
                case 2:
                  _messages.add(ChatMessage(text: "알고 싶은 정보를 골라달라냥!"));
                  _menuSelected = 3;
                  break;
                case 3:
                  _messages.add(ChatMessage(text: "밑에서 원하는 기관을 검색하라냥!"));
                  break;
              }
            });
          },
          child: Row(children: <Widget>[
            Image.asset(
              _selected == index
                  ? _buttonAsset[index][0]
                  : _buttonAsset[index][1],
              height: 25,
              width: 25,
            ),
            Text(
              _buttonName[index],
              style: TextStyle(
                  fontSize: 16,
                  color: _selected == index ? Colors.white : Colors.black),
            )
          ]),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          color: _selected == index
              ? Color.fromARGB(255, 20, 75, 170)
              : Colors.white,
          elevation: 6,
          focusColor: Colors.blue,
        ),
      );
    });
    return _listButtons;
  }

  List<Widget> _buildTransportButtons() {
    List<Widget> _listButtons =
        List.generate(_buttonTransportName.length, (index) {
      return RaisedButton(
        onPressed: () {
          setState(() {
            _selected = index;
            switch (index) {
              case 0:
                // var result = getShuttleBusInfoList();
                showMaterialModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (context, scrollController) => ClipRRect(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
                      child: Container(
                        height: 450,
                        color: Color.fromARGB(255, 20, 75, 170),
                        child: Column(
                          children: [
                            Container(
                              height: 60,
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: IconButton(icon: Icon(Icons.refresh, color: Colors.white,), onPressed: ()=>{},),),),
                            Container(child: CustomPaint(size: Size(MediaQuery.of(context).size.width, 130), painter: BusLaneDirectStation(),),),
                            Container(child: CustomPaint(size: Size(MediaQuery.of(context).size.width, 130), painter: BusLaneDirectTerminal(),),),
                            Container(child: CustomPaint(size: Size(MediaQuery.of(context).size.width, 130), painter: BusLaneCycle(),),)
                          ],
                      ),)
                  ),
                  useRootNavigator: false
                );
                break;
              case 1:
                showMaterialModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (context, scrollController) => ClipRRect(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
                        child: Container(
                          height: 450,
                          color: Color.fromARGB(255, 20, 75, 170),
                          child: DefaultTabController(
                            length: 2,
                            child: Scaffold(
                              appBar: PreferredSize(
                                preferredSize: Size.fromHeight(50),
                                child: AppBar(
                                  automaticallyImplyLeading: false,
                                  backgroundColor: Color.fromARGB(255, 20, 75, 170),
                                  elevation: 0,
                                  bottom: TabBar(
                                    labelColor: Color.fromARGB(255, 20, 75, 170),
                                    unselectedLabelColor: Colors.white,
                                    indicatorSize: TabBarIndicatorSize.label,
                                    indicator: BoxDecoration(
                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
                                      color: Colors.white
                                    ),
                                    tabs: [
                                      Tab(child: Align(alignment: Alignment.center, child: Text("4호선"),),),
                                      Tab(child: Align(alignment: Alignment.center, child: Text("수인분당선"),),),
                                    ],
                                  ),
                                ),
                              ),
                              body: TabBarView(
                                children: [
                                  Container(
                                    color: Color.fromARGB(255, 20, 75, 170),
                                    padding: EdgeInsets.symmetric(vertical: 15.0),
                                    child: Column(
                                      children: [
                                        CustomPaint(size: Size(MediaQuery.of(context).size.width, 170), painter: MetroLineRight(["한대앞", "중앙", "고잔", "초지", "안산"]),),
                                        CustomPaint(size: Size(MediaQuery.of(context).size.width, 170), painter: MetroLineLeft(["한대앞", "상록수", "반월", "대야미", "수리산"]),),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    color: Color.fromARGB(255, 20, 75, 170),
                                    padding: EdgeInsets.symmetric(vertical: 15.0),
                                    child: Column(
                                      children: [
                                        CustomPaint(size: Size(MediaQuery.of(context).size.width, 170), painter: MetroLineRight(["한대앞", "중앙", "고잔", "초지", "안산"]),),
                                        CustomPaint(size: Size(MediaQuery.of(context).size.width, 170), painter: MetroLineLeft(["한대앞","사리", "야목", "어천", "오목천"]),),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        )
                    ),
                    useRootNavigator: false
                );
                break;
              case 2:
                showMaterialModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (context, scrollController) => ClipRRect(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
                        child: Container(
                            height: 450,
                            color: Color.fromARGB(255, 20, 75, 170),
                            child: DefaultTabController(
                              length: 3,
                              child: FutureBuilder(
                                future: getBusInfoList(),
                                builder: (context, snapshot){
                                  if(snapshot.hasError) return Container();
                                  if (snapshot.hasData) {
                                    List<dynamic> data = snapshot.data as List;
                                    Map<String, BusInfoRealtime> realtimeData = data[0];
                                    Map<String, List<BusInfoTimetable>> timeTableData = data[1];
                                    return Scaffold(
                                      appBar: PreferredSize(
                                        preferredSize: Size.fromHeight(50),
                                        child: AppBar(
                                          automaticallyImplyLeading: false,
                                          backgroundColor: Color.fromARGB(
                                              255, 20, 75, 170),
                                          elevation: 0,
                                          bottom: TabBar(
                                            labelColor: Color.fromARGB(
                                                255, 20, 75, 170),
                                            unselectedLabelColor: Colors.white,
                                            indicatorSize: TabBarIndicatorSize
                                                .label,
                                            indicator: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(
                                                        10.0),
                                                    topRight: Radius.circular(
                                                        10.0)),
                                                color: Colors.white
                                            ),
                                            tabs: [
                                              Tab(child: Align(
                                                alignment: Alignment.center,
                                                child: Text("상록수역(10-1)"),),),
                                              Tab(child: Align(
                                                alignment: Alignment.center,
                                                child: Text("강남역(3102)"),),),
                                              Tab(child: Align(
                                                alignment: Alignment.center,
                                                child: Text("수원역(707-1)"),),),
                                            ],
                                          ),
                                        ),
                                      ),
                                      body: TabBarView(
                                        children: [
                                          Container(
                                            color: Color.fromARGB(
                                                255, 20, 75, 170),
                                            padding: EdgeInsets.symmetric(
                                                vertical: 15.0),
                                            child: CustomPaint(
                                              size: Size(MediaQuery
                                                  .of(context)
                                                  .size
                                                  .width, 400),
                                              painter: BusLine([
                                                "한양대게스트하우스",
                                                "한국생산기술연구원",
                                                "한양대기숙사앞",
                                                "경기테크노파크"
                                              ],
                                              realtimeData["10-1"],
                                              timeTableData["10-1"],
                                              terminalStop: "푸르지오6차후문"
                                              ),
                                            ),
                                          ),
                                          Container(
                                            color: Color.fromARGB(
                                                255, 20, 75, 170),
                                            padding: EdgeInsets.symmetric(
                                                vertical: 15.0),
                                            child: CustomPaint(
                                              size: Size(MediaQuery
                                                  .of(context)
                                                  .size
                                                  .width, 400),
                                              painter: BusLine([
                                                "한양대게스트하우스",
                                                "한국생산기술연구원",
                                                "한양대기숙사앞",
                                                "경기테크노파크"
                                              ],
                                              realtimeData['3102'],
                                              timeTableData["3102"],
                                              terminalStop: "송산그린시티"),
                                            ),
                                          ),
                                          Container(
                                            color: Color.fromARGB(
                                                255, 20, 75, 170),
                                            padding: EdgeInsets.symmetric(
                                                vertical: 15.0),
                                            child: CustomPaint(
                                              size: Size(MediaQuery
                                                  .of(context)
                                                  .size
                                                  .width, 400),
                                              painter: BusLine([
                                                "한양대정문",
                                                "고잔1차푸르지오",
                                                "송호초교",
                                                "네오빌6단지",
                                                "화승타운",
                                                "홈플러스"
                                              ],
                                              realtimeData['707-1'],
                                              timeTableData['707-1']),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  } else {
                                    return Center(child: CircularProgressIndicator());
                                  }
                                }
                              ),
                            )
                        )
                    ),
                    useRootNavigator: false
                );
                break;
            }
          });
        },
        child: Row(children: <Widget>[
          Text(
            _buttonTransportName[index],
            style: TextStyle(
                fontSize: 16,
                color: _selected == index ? Colors.white : Colors.black),
          )
        ]),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        color: _selected == index
            ? Color.fromARGB(255, 20, 75, 170)
            : Colors.white,
        elevation: 6,
        focusColor: Colors.blue,
      );
    });
    return _listButtons;
  }

  List<Widget> _buildFoodButtons() {
    List<Widget> _listButtons = List.generate(_buttonFoodName.length, (index) {
      return Container(
        margin: EdgeInsets.only(right: 10),
        child: RaisedButton(
          onPressed: () {
            setState(() {
              _selected = index;
              switch (index) {
                case 0:
                  break;
                case 1:
                  break;
                case 2:
                  break;
                case 3:
                  break;
              }
            });
          },
          child: Row(children: <Widget>[
            Text(
              _buttonFoodName[index],
              style: TextStyle(
                  fontSize: 16,
                  color: _selected == index ? Colors.white : Colors.black),
            )
          ]),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          color: _selected == index
              ? Color.fromARGB(255, 20, 75, 170)
              : Colors.white,
          elevation: 6,
          focusColor: Colors.blue,
        ),
      );
    });
    return _listButtons;
  }

  List<Widget> _buildLibraryButtons() {
    List<Widget> _listButtons =
        List.generate(_buttonLibraryName.length, (index) {
      return RaisedButton(
        onPressed: () {
          setState(() {
            _selected = index;
            switch (index) {
              case 0:
                // List<Widget> _listTransportButtons
                break;
              case 1:
                break;
              case 2:
                // _messages.add(ChatMessage(text: "도서 검색과 열람실 좌석 중에 골라달라냥!"));
                break;
              case 3:
                // _messages.add(ChatMessage(text: "어떤 번호를 검색할지 골라달라냥!"));
                break;
            }
          });
        },
        child: Row(children: <Widget>[
          Text(
            _buttonLibraryName[index],
            style: TextStyle(
                fontSize: 16,
                color: _selected == index ? Colors.white : Colors.black),
          )
        ]),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        color: _selected == index
            ? Color.fromARGB(255, 20, 75, 170)
            : Colors.white,
        elevation: 6,
        focusColor: Colors.blue,
      );
    });
    return _listButtons;
  }
}
