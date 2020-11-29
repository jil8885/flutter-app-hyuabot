import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_hyuabot_v2/Config/GlobalVars.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
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
              title: "설정",
              tiles: [
                SettingsTile(
                  title: "테마",
                  leading: Icon(Icons.wb_sunny),
                  onTap: ()=>{
                    showDialog(
                        context: context,
                        child: SimpleDialog(
                          title: Text("테마를 선택해주세요."),
                          children: [
                            SimpleDialogOption(child: Text("시스템(자동)", style: Theme.of(context).textTheme.bodyText1,), onPressed: (){
                              AdaptiveTheme.of(context).setSystem();
                              Navigator.pop(context);
                              adController.reloadAd(forceRefresh: true);
                            },),
                            SimpleDialogOption(child: Text("주간", style: Theme.of(context).textTheme.bodyText1,), onPressed: (){
                              AdaptiveTheme.of(context).setLight();
                              Navigator.pop(context);
                              adController.reloadAd(forceRefresh: true);
                            },),
                            SimpleDialogOption(child: Text("야간", style: Theme.of(context).textTheme.bodyText1,), onPressed: (){
                              AdaptiveTheme.of(context).setDark();
                              Navigator.pop(context);
                              adController.reloadAd(forceRefresh: true);
                            },),
                          ],
                        ))
                  },),
                // SettingsTile(
                //   title: Translations.of(context).trans("language_title"),
                //   leading: Icon(Icons.language),
                //   onTap: ()=>{
                //     showDialog(
                //         context: context,
                //         child: SimpleDialog(
                //           title: Text(Translations.of(context).trans("language_dialog_title")),
                //           children: [
                //             SimpleDialogOption(child: Text("한국어", style: Theme.of(context).textTheme.bodyText1,), onPressed: (){
                //               prefs.setString("localeCode", "ko_KR");
                //               Phoenix.rebirth(context);
                //             },),
                //             SimpleDialogOption(child: Text("English", style: Theme.of(context).textTheme.bodyText1,), onPressed: (){
                //               prefs.setString("localeCode", "en_US");
                //               Phoenix.rebirth(context);
                //             },),
                //             SimpleDialogOption(child: Text("中國語", style: Theme.of(context).textTheme.bodyText1,), onPressed: (){
                //               prefs.setString("localeCode", "zh");
                //               Phoenix.rebirth(context);
                //             },),
                //           ],
                //         ))
                //   },),
              ],
            )
          ],
        ),
      ),
    );
  }

}