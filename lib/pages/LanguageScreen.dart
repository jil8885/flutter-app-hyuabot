import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguagesScreen extends StatefulWidget {
  @override
  _LanguagesScreenState createState() => _LanguagesScreenState();
}

class _LanguagesScreenState extends State<LanguagesScreen> {
  SharedPreferences _prefManager;

  @override
  void initState() {
    super.initState();
    _initPrefManager();
  }

  @override
  Widget build(BuildContext context) {
    List<String> languages = ["한국어", "English"];
    List<Flag> flags = [Flag('KR', height: 45, width: 50,), Flag('US', height: 45, width: 50,)];
    return AlertDialog(
      content: Container(
        height: 100,
        width: 150,
        child: ListView(
          children: [
            InkWell(
                child: ListTile(leading: flags[0], title: Text(languages[0], textAlign: TextAlign.center,),
                onTap: (){
                  if(_prefManager.getStringList("language")[1] != "KR") {
                    _prefManager.setStringList("language", ["ko", "KR"]);
                    Phoenix.rebirth(context);
                  } else {
                    Navigator.pop(context);
                  }
                },)),
            InkWell(
                child: ListTile(leading: flags[1], title: Text(languages[1], textAlign: TextAlign.center),),
                onTap: (){
                  if(_prefManager.getStringList("language")[1] != "US") {
                    _prefManager.setStringList("language", ["en", "US"]);
                    Phoenix.rebirth(context);
                  } else {
                    Navigator.pop(context);
                  }
                },
            ),
          ],
        ),
      ),
    );
  }

  void _initPrefManager() async{
    _prefManager = await SharedPreferences.getInstance();
  }
}