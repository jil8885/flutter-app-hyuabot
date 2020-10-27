import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';


class BrightnessSettingScreen extends StatefulWidget {
  @override
  _BrightnessSettingScreen createState() => _BrightnessSettingScreen();
}

class _BrightnessSettingScreen extends State<BrightnessSettingScreen> {
  SharedPreferences _prefManager;

  @override
  void initState() {
    super.initState();
    _initPrefManager();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        height: 180,
        width: 150,
        child: ListView(
          children: [
            InkWell(
                child: ListTile(leading: Icon(Icons.wb_sunny), title: Text("light_mode".tr(), textAlign: TextAlign.center,),
                  onTap: (){
                    if(_prefManager.getString("darkMode") != "false") {
                      _prefManager.setString("darkMode", "false");
                      Phoenix.rebirth(context);
                    } else {
                      Navigator.pop(context);
                    }
                  },)),
            InkWell(
                child: ListTile(leading: Icon(Icons.nightlight_round), title: Text("dark_mode".tr(), textAlign: TextAlign.center,),
                  onTap: (){
                    if(_prefManager.getString("darkMode") != "true") {
                      _prefManager.setString("darkMode", "true");
                      Phoenix.rebirth(context);
                    } else {
                      Navigator.pop(context);
                    }
                  },)),
            InkWell(
                child: ListTile(leading: Icon(Icons.brightness_auto), title: Text("auto_mode".tr(), textAlign: TextAlign.center,),
                  onTap: (){
                    if(_prefManager.getString("darkMode") != "auto") {
                      _prefManager.setString("darkMode", "auto");
                      Phoenix.rebirth(context);
                    } else {
                      Navigator.pop(context);
                    }
                  },)),
          ],
        ),
      ),
    );
  }

  void _initPrefManager() async{
    _prefManager = await SharedPreferences.getInstance();
  }
}