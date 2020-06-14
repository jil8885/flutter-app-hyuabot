import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'style.dart';

void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  // 홈화면 상태 빌드 함수
  @override
  Widget build(BuildContext context) {
    // 전체 스크린
    return Scaffold(
      appBar: EmptyAppBar(),
      body: Container(
        color: Color(0xffc5c5c5),
        child: Column(children: <Widget>[
          // 로고 부분
          Container(margin: const EdgeInsets.all(10.0), child: Image.asset('images/logo-food.png'),),
          // 메인 화면
          Expanded(child: Container(
            color: Color(0xff747474)
          ),),
          // 버튼 부분(전체 공간)
          Container(
            // 버튼 widget 코드
            child: Row(
              children:<Widget>[
                // 하단 학식 버튼
                RaisedButton(
                    onPressed: ()=>showMessage("food"),
                    child: Row(children: <Widget>[Image.asset('images/icon-food.png', height: 32, width: 32,), Text("학식", style: TextStyle(fontSize: 20),)]),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0), ),
                    color: Colors.white,
                    elevation: 6,
                    focusColor: Colors.blue,
                ),
                // 하단 도서 버튼
                RaisedButton(
                    onPressed: ()=>showMessage("food"),
                    child: Row(children: <Widget>[Image.asset('images/icon-book.png', height: 32, width: 32,), Text("도서", style: TextStyle(fontSize: 20),)]),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0), ),
                    color: Colors.white,
                    elevation: 6,
                    focusColor: Colors.blue,
                ),
                // 하단 교통 버튼
                RaisedButton(
                    onPressed: ()=>showMessage("food"),
                    child: Row(children: <Widget>[Image.asset('images/icon-bus.png', height: 32, width: 32,), Text("교통", style: TextStyle(fontSize: 20),)]),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0), ),
                    color: Colors.white,
                    elevation: 6,
                    focusColor: Colors.blue,
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            )
          )
        ],)
      )
    );
  }

  // 메세지 출력 함수
  void showMessage(String msg) {
    print(msg);
  }
}
