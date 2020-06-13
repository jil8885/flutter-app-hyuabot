// dart class file for style

// Empty App bar 
import 'package:flutter/widgets.dart';

class EmptyAppBar extends StatelessWidget implements PreferredSizeWidget{
  @override
  Widget build(BuildContext context) {
    return Container();
  }

  @override
  Size get preferredSize => Size(0.0, 0.0);
}