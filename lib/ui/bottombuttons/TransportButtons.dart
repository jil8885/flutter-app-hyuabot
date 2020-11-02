import 'package:chatbot/main.dart';
import 'package:chatbot/config/common.dart';
import 'package:chatbot/ui/bottomsheets/TransportSheets.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class TransportMenuButtons extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        backMenuButton(context),
        Flexible(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _makeFuncButton(context, "셔틀", 0, "assets/images/shared/sheet-header-shuttle.png"),
              _makeFuncButton(context, "전철", 1, "assets/images/shared/sheet-header-metro.png"),
              _makeFuncButton(context, "노선버스", 2, "assets/images/shared/sheet-header-bus.png"),
            ],
          ),
        ),
      ],
    );
  }

  Widget _makeFuncButton(BuildContext context, String buttonText, int index, String assetPath){
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
              showMaterialModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (context, scrollController) => TransportSheets(assetPath));
            },
          ),
        );
      }
    );
  }
}