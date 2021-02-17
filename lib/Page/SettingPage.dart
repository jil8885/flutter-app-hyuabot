import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_app_hyuabot_v2/Config/GlobalVars.dart';
import 'package:settings_ui/settings_ui.dart';


class SettingPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    analytics.setCurrentScreen(screenName: "/setting");
    return Scaffold(
      body: Container(
        color: Theme.of(context).backgroundColor,
        padding: EdgeInsets.all(10.0),
        child: SettingsList(
          backgroundColor: Colors.transparent,
          sections: [
            SettingsSection(
              title: "setting_title".tr(),
              tiles: [
                SettingsTile(
                  title: "theme_title".tr(),
                  titleTextStyle: TextStyle(color: Theme.of(context).textTheme.bodyText2.color),
                  leading: Icon(Icons.wb_sunny),
                  onTap: ()=>{
                    showDialog(
                        context: context,
                        builder: (_) => SimpleDialog(
                          title: Text("theme_dialog_title".tr(), style: TextStyle(color: Theme.of(context).textTheme.bodyText2.color),),
                          children: [
                            SimpleDialogOption(child: Text("set_theme_system".tr(), style: TextStyle(color: Theme.of(context).textTheme.bodyText2.color),), onPressed: (){
                              AdaptiveTheme.of(context).setSystem();
                              prefManager.setString("theme", "auto");
                              Navigator.of(context).pop();
                              adController.reloadAd(forceRefresh: true);
                            },),
                            SimpleDialogOption(child: Text("set_theme_light".tr(), style: TextStyle(color: Theme.of(context).textTheme.bodyText2.color),), onPressed: (){
                              AdaptiveTheme.of(context).setLight();
                              prefManager.setString("theme", "light");
                              Navigator.of(context).pop();
                              adController.reloadAd(forceRefresh: true);
                            },),
                            SimpleDialogOption(child: Text("set_theme_dark".tr(), style: TextStyle(color: Theme.of(context).textTheme.bodyText2.color),), onPressed: (){
                              AdaptiveTheme.of(context).setDark();
                              prefManager.setString("theme", "dark");
                              Navigator.of(context).pop();
                              adController.reloadAd(forceRefresh: true);
                            },),
                          ],
                        ))
                  },),
                SettingsTile(
                  title: "language_title".tr(),
                  titleTextStyle: TextStyle(color: Theme.of(context).textTheme.bodyText2.color),
                  leading: Icon(Icons.language),
                  onTap: ()=>{
                    showDialog(
                        context: context,
                        child: SimpleDialog(
                          title: Text("language_dialog_title".tr()),
                          children: [
                            SimpleDialogOption(child: Text("한국어", style: Theme.of(context).textTheme.bodyText2,), onPressed: (){
                              prefManager.setString("localeCode", "ko_KR");
                              context.locale = Locale("ko", "KR");
                              Navigator.of(context).pop();
                            },),
                            SimpleDialogOption(child: Text("English", style: Theme.of(context).textTheme.bodyText2,), onPressed: (){
                              prefManager.setString("localeCode", "en_US").whenComplete((){
                                context.locale = Locale("en", "US");
                                Navigator.of(context).pop();
                              });
                            },),
                            SimpleDialogOption(child: Text("中國語", style: Theme.of(context).textTheme.bodyText2,), onPressed: (){
                              prefManager.setString("localeCode", "zh");
                              context.locale = Locale("zh");
                              Navigator.of(context).pop();
                            },),
                          ],
                        ))
                  },),
                SettingsTile(
                  title: "thanks_for_someone".tr(),
                  titleTextStyle: TextStyle(color: Theme.of(context).textTheme.bodyText2.color),
                  leading: Icon(Icons.people),
                  onTap: (){
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text("thanks_for_someone".tr(), style: TextStyle(color: Theme.of(context).textTheme.bodyText2.color,),),
                        content: Column(
                          children: [
                            Text("소프트웨어학부19 유진웅(디자인)", style: TextStyle(color: Theme.of(context).textTheme.bodyText2.color, fontSize: 16),),
                            SizedBox(height: 5,),
                            Text("중국학과16 이용찬(번역)", style: TextStyle(color: Theme.of(context).textTheme.bodyText2.color, fontSize: 16),),
                          ],
                        ),
                      )
                    );
                  }
                )
              ],
            )
          ],
        ),
      ),
    );
  }

}