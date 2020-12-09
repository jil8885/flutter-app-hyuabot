import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_hyuabot_v2/Config/GlobalVars.dart';
import 'package:flutter_app_hyuabot_v2/Config/Localization.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:get/get.dart';
import 'package:settings_ui/settings_ui.dart';


class SettingPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).backgroundColor,
        padding: EdgeInsets.all(10.0),
        child: SettingsList(
          backgroundColor: Colors.transparent,
          sections: [
            SettingsSection(
              title: TranslationManager.of(context).trans("setting_title"),
              tiles: [
                SettingsTile(
                  title: TranslationManager.of(context).trans("theme_title"),
                  titleTextStyle: TextStyle(fontFamily: "Godo", color: Theme.of(context).textTheme.bodyText1.color),
                  leading: Icon(Icons.wb_sunny),
                  onTap: ()=>{
                    showDialog(
                        context: context,
                        builder: (_) => SimpleDialog(
                          title: Text(TranslationManager.of(context).trans("theme_dialog_title"), style: TextStyle(fontFamily: "Godo", color: Theme.of(context).textTheme.bodyText1.color),),
                          children: [
                            SimpleDialogOption(child: Text(TranslationManager.of(context).trans("set_theme_system"), style: TextStyle(fontFamily: "Godo", color: Theme.of(context).textTheme.bodyText1.color),), onPressed: (){
                              AdaptiveTheme.of(context).setSystem();
                              Navigator.pop(context);
                              adController.reloadAd(forceRefresh: true);
                            },),
                            SimpleDialogOption(child: Text(TranslationManager.of(context).trans("set_theme_light"), style: TextStyle(fontFamily: "Godo", color: Theme.of(context).textTheme.bodyText1.color),), onPressed: (){
                              AdaptiveTheme.of(context).setLight();
                              Navigator.pop(context);
                              adController.reloadAd(forceRefresh: true);
                            },),
                            SimpleDialogOption(child: Text(TranslationManager.of(context).trans("set_theme_dark"), style: TextStyle(fontFamily: "Godo", color: Theme.of(context).textTheme.bodyText1.color),), onPressed: (){
                              AdaptiveTheme.of(context).setDark();
                              Navigator.pop(context);
                              adController.reloadAd(forceRefresh: true);
                            },),
                          ],
                        ))
                  },),
                SettingsTile(
                  title: TranslationManager.of(context).trans("language_title"),
                  titleTextStyle: TextStyle(fontFamily: "Godo", color: Theme.of(context).textTheme.bodyText1.color),
                  leading: Icon(Icons.language),
                  onTap: ()=>{
                    showDialog(
                        context: context,
                        child: SimpleDialog(
                          title: Text(TranslationManager.of(context).trans("language_dialog_title")),
                          children: [
                            SimpleDialogOption(child: Text("한국어", style: Theme.of(context).textTheme.bodyText1,), onPressed: (){
                              prefManager.setString("localeCode", "ko_KR");
                              Phoenix.rebirth(context);
                            },),
                            SimpleDialogOption(child: Text("English", style: Theme.of(context).textTheme.bodyText1,), onPressed: (){
                              prefManager.setString("localeCode", "en_US");
                              Phoenix.rebirth(context);
                            },),
                            SimpleDialogOption(child: Text("中國語", style: Theme.of(context).textTheme.bodyText1,), onPressed: (){
                              prefManager.setString("localeCode", "zh");
                              Phoenix.rebirth(context);
                            },),
                          ],
                        ))
                  },),
                SettingsTile(
                  title: TranslationManager.of(context).trans("thanks_for_someone"),
                  titleTextStyle: TextStyle(fontFamily: "Godo", color: Theme.of(context).textTheme.bodyText1.color),
                  leading: Icon(Icons.people),
                  onTap: () => {
                    Get.defaultDialog(
                      title: TranslationManager.of(context).trans("thanks_for_someone"),
                      titleStyle: TextStyle(fontFamily: "Godo", color: Theme.of(context).textTheme.bodyText1.color,),
                      content: Column(
                        children: [
                          Text("소프트웨어학부19 유진웅(디자인)", style: TextStyle(fontFamily: "Godo", color: Theme.of(context).textTheme.bodyText1.color, fontSize: 16),),
                          SizedBox(height: 5,),
                          Text("중국학과16 이용찬(번역)", style: TextStyle(fontFamily: "Godo", color: Theme.of(context).textTheme.bodyText1.color, fontSize: 16),),
                        ],
                      ),
                    )
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }

}