import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_hyuabot_v2/Config/GlobalVars.dart';
import 'package:get/get.dart';
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
              title: "setting_title".tr,
              tiles: [
                SettingsTile(
                  title: "theme_title".tr,
                  titleTextStyle: TextStyle(color: Theme.of(context).textTheme.bodyText1.color),
                  leading: Icon(Icons.wb_sunny),
                  onTap: ()=>{
                    showDialog(
                        context: context,
                        builder: (_) => SimpleDialog(
                          title: Text("theme_dialog_title".tr, style: TextStyle(color: Theme.of(context).textTheme.bodyText1.color),),
                          children: [
                            SimpleDialogOption(child: Text("set_theme_system".tr, style: TextStyle(color: Theme.of(context).textTheme.bodyText1.color),), onPressed: (){
                              AdaptiveTheme.of(context).setSystem();
                              Navigator.pop(context);
                              adController.reloadAd(forceRefresh: true);
                            },),
                            SimpleDialogOption(child: Text("set_theme_light".tr, style: TextStyle(color: Theme.of(context).textTheme.bodyText1.color),), onPressed: (){
                              AdaptiveTheme.of(context).setLight();
                              Navigator.pop(context);
                              adController.reloadAd(forceRefresh: true);
                            },),
                            SimpleDialogOption(child: Text("set_theme_dark".tr, style: TextStyle(color: Theme.of(context).textTheme.bodyText1.color),), onPressed: (){
                              AdaptiveTheme.of(context).setDark();
                              Navigator.pop(context);
                              adController.reloadAd(forceRefresh: true);
                            },),
                          ],
                        ))
                  },),
                SettingsTile(
                  title: "language_title".tr,
                  titleTextStyle: TextStyle(color: Theme.of(context).textTheme.bodyText1.color),
                  leading: Icon(Icons.language),
                  onTap: ()=>{
                    showDialog(
                        context: context,
                        child: SimpleDialog(
                          title: Text("language_dialog_title".tr),
                          children: [
                            SimpleDialogOption(child: Text("한국어", style: Theme.of(context).textTheme.bodyText1,), onPressed: (){
                              prefManager.setString("localeCode", "ko_KR");
                              Get.updateLocale(Locale("ko_KR"));
                            },),
                            SimpleDialogOption(child: Text("English", style: Theme.of(context).textTheme.bodyText1,), onPressed: (){
                              prefManager.setString("localeCode", "en_US").whenComplete((){
                                Get.updateLocale(Locale("en_US"));
                              });
                            },),
                            // 중국어 번역 이후 추가
                            // SimpleDialogOption(child: Text("中國語", style: Theme.of(context).textTheme.bodyText1,), onPressed: (){
                            //   prefManager.setString("localeCode", "zh");
                            //   Phoenix.rebirth(context);
                            // },),
                          ],
                        ))
                  },),
                SettingsTile(
                  title: "thanks_for_someone".tr,
                  titleTextStyle: TextStyle(color: Theme.of(context).textTheme.bodyText1.color),
                  leading: Icon(Icons.people),
                  onTap: () => {
                    Get.defaultDialog(
                      title: "thanks_for_someone".tr,
                      titleStyle: TextStyle(color: Theme.of(context).textTheme.bodyText1.color,),
                      content: Column(
                        children: [
                          Text("소프트웨어학부19 유진웅(디자인)", style: TextStyle(color: Theme.of(context).textTheme.bodyText1.color, fontSize: 16),),
                          SizedBox(height: 5,),
                          Text("중국학과16 이용찬(번역)", style: TextStyle(color: Theme.of(context).textTheme.bodyText1.color, fontSize: 16),),
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