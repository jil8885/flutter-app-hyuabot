import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    // 전체 스크린
    return Scaffold(
      body: Container(
        height: 760,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        alignment: Alignment.bottomCenter,
        // 하단 텍스트 입력부
        child: Container(
          height: 42,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(16, 0, 0, 0),
                offset: Offset(0, -1),
                blurRadius: 6,
                spreadRadius: 0,
              ),
            ],
          ),
          // 하단 입력부 화면(텍스트 입력, 전송 버튼)
          child: Row(
            children: <Widget>[
              //입력 부분
              SizedBox(
                width: 329,
                height: 42,
                child: TextField(
                // 힌트 텍스트
                decoration: InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  hintText: '메세지를 입력해주세요',
                  hintStyle: TextStyle(
                    color: Color(0xffe0e0e0),
                    fontSize: 13,
                    fontFamily: 'NotoSans',
                    fontWeight: FontWeight.w500,
                  ),
                  contentPadding: const EdgeInsets.only(left: 48)
                ),
                textAlignVertical: TextAlignVertical.center,
              ),
              )
              // 전송 버튼 부분

            ],
          ),
        ),
      ),
    );
  }
}
