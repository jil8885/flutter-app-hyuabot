import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:chatbot/config/Localization.dart';
import 'package:chatbot/pages/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:settings_ui/settings_ui.dart';

import 'package:chatbot/config/Style.dart';
import 'package:chatbot/main.dart';

class SettingScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(),
      body: Container(
        color: Theme.of(context).backgroundColor,
        padding: EdgeInsets.all(10.0),
        child: SettingsList(
          backgroundColor: Theme.of(context).backgroundColor,

          sections: [
            SettingsSection(
              title: Translations.of(context).trans('setting_title'),
              tiles: [
                SettingsTile(
                  title: Translations.of(context).trans('theme_title'),
                  leading: Icon(Icons.wb_sunny),
                  onTap: ()=>{
                    showDialog(
                      context: context, 
                      child: SimpleDialog(
                        title: Text(Translations.of(context).trans('theme_dialog_title')),
                        children: [
                          SimpleDialogOption(child: Text(Translations.of(context).trans("set_theme_system"), style: Theme.of(context).textTheme.bodyText1,), onPressed: (){
                            AdaptiveTheme.of(context).setSystem();
                            Navigator.pop(context);
                            adController.reloadAd(forceRefresh: true);
                          },),
                          SimpleDialogOption(child: Text(Translations.of(context).trans("set_theme_light"), style: Theme.of(context).textTheme.bodyText1,), onPressed: (){
                            AdaptiveTheme.of(context).setLight();
                            Navigator.pop(context);
                            adController.reloadAd(forceRefresh: true);
                          },),
                          SimpleDialogOption(child: Text(Translations.of(context).trans("set_theme_dark"), style: Theme.of(context).textTheme.bodyText1,), onPressed: (){
                            AdaptiveTheme.of(context).setDark();
                            Navigator.pop(context);
                            adController.reloadAd(forceRefresh: true);
                          },),
                        ],
                      ))
                  },),
                SettingsTile(
                  title: Translations.of(context).trans("language_title"),
                  leading: Icon(Icons.language),
                  onTap: ()=>{
                    showDialog(
                        context: context,
                        child: SimpleDialog(
                          title: Text(Translations.of(context).trans("language_dialog_title")),
                          children: [
                            SimpleDialogOption(child: Text("한국어", style: Theme.of(context).textTheme.bodyText1,), onPressed: (){
                              prefs.setString("localeCode", "ko_KR");
                              Phoenix.rebirth(context);
                            },),
                            SimpleDialogOption(child: Text("English", style: Theme.of(context).textTheme.bodyText1,), onPressed: (){
                              prefs.setString("localeCode", "en_US");
                              Phoenix.rebirth(context);
                            },),
                            SimpleDialogOption(child: Text("中國語", style: Theme.of(context).textTheme.bodyText1,), onPressed: (){
                              prefs.setString("localeCode", "zh");
                              Phoenix.rebirth(context);
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