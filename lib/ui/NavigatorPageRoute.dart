import 'package:flutter/material.dart';

class NavigatorPageRoute<T> extends MaterialPageRoute<T> {

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return child;
  }
}