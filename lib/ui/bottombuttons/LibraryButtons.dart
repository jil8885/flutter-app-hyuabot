import 'package:chatbot/config/common.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class LibraryMenuButtons extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        backMenuButton(),
        Row(
          children: [
            _makeFuncButton(context, "도서 검색", 0, Container()),
            _makeFuncButton(context, "열람실", 1, Container()),
          ],
        ),
      ],
    );
  }

  Widget _makeFuncButton(BuildContext context, String buttonText, int index, Widget bottomSheet){
    return RaisedButton(
      child: Text(buttonText, style: TextStyle(fontSize: 11, fontFamily: "Noto Sans KR", color: pressedSubButton == index ? Colors.white : Colors.black),),
      color: pressedSubButton == index ? Theme.of(context).accentColor : Colors.white,
      elevation: 6,
      onPressed: (){
        showMaterialModalBottomSheet(context: context, builder: null);
      },
    );
  }

}