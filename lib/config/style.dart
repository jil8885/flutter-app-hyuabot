// dart class file for style

// Empty App bar 
import 'package:flutter/widgets.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
      color: primaryColor,
    );
  }

  @override
  Size get preferredSize => Size(0, 0);
}

Color primaryColor = Color.fromARGB(255, 20, 75, 170);