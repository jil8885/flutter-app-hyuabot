import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  ChatMessage({this.chat});
  final Widget chat;
  @override Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row( crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 8.0),
            child: CircleAvatar(
                child: Container(
                    decoration: new BoxDecoration(image:DecorationImage(image: new AssetImage("assets/images/shared/hanyang.png"), fit: BoxFit.fill))
                )
            ),
          ),
          Column( crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Text("하냥이", style: themeData.textTheme.bodyText1),
              ),
              Bubble(
                nip: BubbleNip.leftTop,
                nipWidth: 5,
                margin: BubbleEdges.only(top:5.0),
                color: themeData.cardColor,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * .3, maxWidth: MediaQuery.of(context).size.width * .5),
                  child: chat,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
