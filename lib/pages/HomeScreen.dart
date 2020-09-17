import 'package:chatbot/ui/ChatMessage.dart';
import 'package:flutter/material.dart';

import 'package:chatbot/style.dart';

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
    List<List<Widget>> _menus = [_buildButtons(), _buildTransportButtons()];
    // 전체 스크린
    return Scaffold(
        appBar: EmptyAppBar(),
        body: WillPopScope(
          child: Container(
              color: Color.fromRGBO(239, 244, 244, 0),
              child: Column(children: <Widget>[
                // 로고 부분
                Container(
                  margin: const EdgeInsets.all(10.0),
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
                Row(
                  children: _menus[_menuSelected],
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                ),
                // 메세지 전송 버튼
                Container(
                  height: 50,
                  child: Row(
                    children: [
                      Flexible(
                        child: TextField(
                          decoration: InputDecoration(
                              hintText: "메세지를 입력해주세요.",
                              contentPadding: const EdgeInsets.only(left: 20),
                              border: InputBorder.none),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: IconButton(icon: Icon(Icons.send)),
                      ),
                    ],
                  ),
                ),
              ])),
          onWillPop: () {
            setState(() {
              if (_menuSelected != 0) {
                _menuSelected = 0;
                _messages.removeLast();
              }
            });
          },
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
              switch (index) {
                case 0:
                  _messages.add(ChatMessage(text: "원하는 교통수단을 골라달라냥!"));
                  _menuSelected = 1;
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
    _listButtons.insert(
        0,
        IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            setState(() {
              _menuSelected = 0;
              _messages.removeLast();
            });
          },
        ));
    return _listButtons;
  }
}
