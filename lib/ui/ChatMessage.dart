import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  ChatMessage({this.text});
  final String text;
  @override Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row( crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 8.0),
            child: CircleAvatar(child: Image.asset("images/hanyang.png")), ),
          Column( crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Text("하냥이", style: TextStyle(fontFamily: "Noto Sans KR")),
              ),
              Bubble(
                nip: BubbleNip.leftTop,
                nipWidth: 5,
                margin: BubbleEdges.only(top:5.0),
                child: Text(text),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
