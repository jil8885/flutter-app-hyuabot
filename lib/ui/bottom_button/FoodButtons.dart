import 'package:chatbot/config/Localization.dart';
import 'package:chatbot/main.dart';
import 'package:chatbot/config/Common.dart';
import 'package:flutter/material.dart';

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
                _makeFuncButton(context, Translations.of(context).trans("student_cafeteria_btn"), 0, "student"),
                _makeFuncButton(context, Translations.of(context).trans("teacher_cafeteria_btn"), 1, "teacher"),
                _makeFuncButton(context, Translations.of(context).trans("dorm_cafeteria_btn"), 2, "dormitory"),
                _makeFuncButton(context, Translations.of(context).trans("changbo_cafeteria_btn"), 3, "changbo"),
                _makeFuncButton(context, Translations.of(context).trans("food_court"), 4, "foodcoart"),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _makeFuncButton(BuildContext context, String buttonText, int index, String restaurant){
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
                chatController.fetchMenu(restaurant, context);
              },
            ),
          );
        }
    );
  }
}