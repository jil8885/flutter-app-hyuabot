import 'package:flutter/material.dart';

class LibrarySheets extends StatelessWidget{
  LibrarySheets(this.contents);
  final Widget contents;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: Container()),
        ClipRRect(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
          child: Container(
            height: 350,
            width: MediaQuery.of(context).size.width,
            color: Theme.of(context).accentColor,
            child: contents,
          ),
        ),
      ],
    );
  }
}