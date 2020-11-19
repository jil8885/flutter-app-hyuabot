import 'package:flutter/material.dart';

class TelephoneSheets extends StatelessWidget{
  TelephoneSheets(this.contents);
  final Widget contents;
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
                height: MediaQuery.of(context).size.height * 0.4,
                width: MediaQuery.of(context).size.width,
                color: Theme.of(context).accentColor,
                child: contents,
              ),
            ),
          ],
        ),
        Positioned(
          bottom: MediaQuery.of(context).size.height * 0.35,
          right: -5,
          child: SizedBox(
            child: Container(child: Image.asset("assets/images/shared/sheet-header-telephone.png")),
            height: 180,
            width: 180,
          ),
        )
      ],
    );
  }
}