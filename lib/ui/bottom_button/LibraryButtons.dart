import 'dart:async';

import 'package:chatbot/main.dart';
import 'package:chatbot/config/common.dart';
import 'package:chatbot/model/ReadingRoom.dart';
import 'package:chatbot/ui/bottom_sheet/LibrarySheets.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';


class LibraryMenuButtons extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => LibraryMenuStates();
}

class LibraryMenuStates extends State<LibraryMenuButtons> with TickerProviderStateMixin{
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
              _makeFuncButton(context, "도서 검색", 0, Container()),
              _makeFuncButton(context, "열람실", 1, _readingRoomSheets(context)),
            ],
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
                timer.cancel();
                switch(index){
                  case 0:
                    timer.cancel();
                    readingRoomOpened = false;
                    break;
                  case 1:
                    timer.cancel();
                    readingRoomOpened = true;
                    break;
                }
                subButtonController.updateSubButtonIndex(index);
                showMaterialModalBottomSheet(context: context, backgroundColor: Colors.transparent, builder: (context, scrollController) => LibrarySheets(bottomSheet));
              },
            ),
          );
        }
    );
  }

  Widget _readingRoomSheets(BuildContext context){
    timer = Timer.periodic(Duration(seconds: 120), (timer) {
      if(readingRoomOpened) {
        readingRoomController.fetch();
      }
    });

    return StreamBuilder<Map<String, ReadingRoomInfo>>(
        stream: readingRoomController.allReadingRoom,
        builder: (context, snapshot) {
          if(snapshot.hasError || !snapshot.hasData){
            return CircularProgressIndicator();
          }
          else {
            List<String> names = [];
            for(String name in snapshot.data.keys){
              if(snapshot.data[name].active != 0){
                names.add(name);
              }
              names.sort();
            }
            return ListView.separated(
                padding: const EdgeInsets.all(8),
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    height: 10,
                  );
                },
                itemCount: names.length,
                itemBuilder: (_, index){
                  return Container(
                    height: 75,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(names[index], style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),),
                        ),
                        Flexible(child: LinearPercentIndicator(
                            width: MediaQuery.of(context).size.width - 120,
                            animation: true,
                            lineHeight: 20.0,
                            animationDuration: 1500,
                            percent: snapshot.data[names[index]].available/snapshot.data[names[index]].active,
                            center: Text("${snapshot.data[names[index]].available}/${snapshot.data[names[index]].active}"),
                            linearStrokeCap: LinearStrokeCap.roundAll,
                            progressColor: Colors.green,
                        ),),
                        // Text("${snapshot.data[names[index]].available}/${snapshot.data[names[index]].active}", style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),),
                      ],
                    ),
                  );
                }
            );
          }
        }
    );
  }
}