import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

import 'package:chatbot/config/style.dart';

class SettingScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(),
      body: Container(
        color: Theme.of(context).backgroundColor,
        child: SettingsList(
          backgroundColor: Theme.of(context).backgroundColor,
          sections: [
            SettingsSection(
              title: "settings",
              tiles: [
                SettingsTile(
                  title: "Dark Mode",
                  leading: Icon(Icons.wb_sunny),
                  onTap: ()=>{
                    showDialog(
                      context: context, 
                      child: SimpleDialog(
                        title: Text("앱 테마를 선택해주세요."),
                        children: [
                          SimpleDialogOption(child: Text("시스템", style: Theme.of(context).textTheme.bodyText1,), onPressed: (){
                            AdaptiveTheme.of(context).setSystem();
                            Navigator.pop(context);
                          },),
                          SimpleDialogOption(child: Text("라이트", style: Theme.of(context).textTheme.bodyText1,), onPressed: (){
                            AdaptiveTheme.of(context).setLight();
                            Navigator.pop(context);
                          },),
                          SimpleDialogOption(child: Text("다크", style: Theme.of(context).textTheme.bodyText1,), onPressed: (){
                            AdaptiveTheme.of(context).setDark();
                            Navigator.pop(context);
                          },),
                        ],
                      ))
                  },),
                SettingsTile(
                  title: "Language",
                  leading: Icon(Icons.language),
                  onTap: ()=>{
                    showDialog(
                        context: context,
                        child: SimpleDialog(
                          title: Text("언어를 선택해주세요."),
                          children: [
                            SimpleDialogOption(child: Text("한국어", style: Theme.of(context).textTheme.bodyText1,), onPressed: (){
                              AdaptiveTheme.of(context).setSystem();
                              Navigator.pop(context);
                            },),
                            SimpleDialogOption(child: Text("English", style: Theme.of(context).textTheme.bodyText1,), onPressed: (){
                              AdaptiveTheme.of(context).setLight();
                              Navigator.pop(context);
                            },),
                            SimpleDialogOption(child: Text("中國語", style: Theme.of(context).textTheme.bodyText1,), onPressed: (){
                              AdaptiveTheme.of(context).setDark();
                              Navigator.pop(context);
                            },),
                          ],
                        ))
                  },),
              ],
            )
          ],
        ),
      )
    );
  }

}