import 'package:chatbot/main.dart';
import 'package:chatbot/config/common.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class FoodMenuButtons extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        backMenuButton(context),
        Flexible(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _makeFuncButton(context, "학생식당", 0, Container()),
                _makeFuncButton(context, "교직원식당", 1, Container()),
                _makeFuncButton(context, "창의인재원식당", 2, Container()),
                _makeFuncButton(context, "창업보육센터", 3, Container()),
                _makeFuncButton(context, "푸드코트", 4, Container()),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _makeFuncButton(BuildContext context, String buttonText, int index, Widget bottomSheet){
    return StreamBuilder<int>(
        stream: subButtonController.subButtonIndex,
        builder: (context, snapshot) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
              child: Text(buttonText, style: TextStyle(fontSize: 12, fontFamily: "Noto Sans KR", color: snapshot.data == index ? Colors.white : Colors.black),),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              color: snapshot.data == index ? Theme.of(context).accentColor : Colors.white,
              elevation: 6,
              onPressed: (){
                subButtonController.updateSubButtonIndex(index);
                showMaterialModalBottomSheet(context: context, builder: null);
              },
            ),
          );
        }
    );
  }
}