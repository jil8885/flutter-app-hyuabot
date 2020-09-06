import 'package:flutter/material.dart';

import 'package:chatbot/style.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _image = Image.asset('images/logo-food.png');
  // 홈화면 상태 빌드 함수
  @override
  Widget build(BuildContext context) {
    // 전체 스크린
    return Scaffold(
        appBar: EmptyAppBar(),
        body: Container(
            color: Color.fromRGBO(239, 244, 244, 0),
            child: Column(children: <Widget>[
              // 로고 부분
              Container(
                margin: const EdgeInsets.all(10.0),
                child: _image,
              ),
              // 메인 화면
              Expanded(
                child: Container(
                  color: Color.fromRGBO(239, 244, 244, 0),
                ),
              ),
              Row(
                children: <Widget>[
                  // 하단 학식 버튼
                  SizedBox(
                    width: 88,
                    child: RaisedButton(
                      onPressed: () => showMessage("food"),
                      child: Row(children: <Widget>[
                        Image.asset(
                          'images/icon-food.png',
                          height: 25,
                          width: 25,
                        ),
                        Text(
                          "학식",
                          style: TextStyle(fontSize: 16),
                        )
                      ]),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      color: Colors.white,
                      elevation: 6,
                      focusColor: Colors.blue,
                    ),
                  ),
                  // 하단 전화번호부 버튼
                  SizedBox(
                    width: 100,
                    child: RaisedButton(
                      onPressed: () => showMessage("food"),
                      child: Row(children: <Widget>[
                        Image.asset(
                          'images/icon-phone.png',
                          height: 25,
                          width: 25,
                        ),
                        Text(
                          "전화부",
                          style: TextStyle(fontSize: 16),
                        )
                      ]),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      color: Colors.white,
                      elevation: 6,
                      focusColor: Colors.blue,
                    ),
                  ),
                  // 하단 도서 버튼
                  SizedBox(
                    width: 88,
                    child: RaisedButton(
                      onPressed: () => showMessage("food"),
                      child: Row(children: <Widget>[
                        Image.asset(
                          'images/icon-book.png',
                          height: 25,
                          width: 25,
                        ),
                        Text(
                          "도서",
                          style: TextStyle(fontSize: 16),
                        )
                      ]),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      color: Colors.white,
                      elevation: 6,
                      focusColor: Colors.blue,
                    ),
                  ),
                  // 하단 교통 버튼
                  SizedBox(
                    width: 88,
                    child: RaisedButton(
                      onPressed: () => pageChange(4),
                      child: Row(children: <Widget>[
                        Image.asset(
                          'images/icon-bus.png',
                          height: 25,
                          width: 25,
                        ),
                        Text(
                          "교통",
                          style: TextStyle(fontSize: 16),
                        )
                      ]),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      color: Colors.white,
                      elevation: 6,
                      focusColor: Colors.blue,
                    ),
                  )
                ],
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              ),
              Container(
                decoration: BoxDecoration(border: Border.all(width: 0.1), color: Colors.white),
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
            ])
        )
    );
  }

  // 메세지 출력 함수
  void showMessage(String msg) {
    print(msg);
  }

  void pageChange(int index) {
    switch (index) {
      case 1:
        _image = Image.asset('images/logo-food.png');
        break;
      case 4:
        _image = Image.asset('images/logo-bus.png');
        break;
    }
  }
}
