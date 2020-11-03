import 'package:flutter/material.dart';

class TransportSheets extends StatelessWidget{
  TransportSheets(this.assetPath, this.contents);
  final Widget contents;
  final assetPath;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Expanded(child: Container()),
            ClipRRect(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
              child: Container(
                height: MediaQuery.of(context).size.height * .35,
                width: MediaQuery.of(context).size.width,
                color: Theme.of(context).accentColor,
                child: contents,
              ),
            ),
          ],
        ),
        Positioned(
          bottom: MediaQuery.of(context).size.height * .30,
          right: -5,
          child: SizedBox(
            child: Container(child: Image.asset(assetPath)),
            height: 180,
            width: 180,
          ),
        )
      ],
    );
  }
}