import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:chatbot/config/style.dart';

import 'LanguageScreen.dart';

class SettingScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: "settings".tr(),
            tiles: [
              SettingsTile(
                title: "language".tr(),
                leading: Icon(Icons.language),
                onTap: (){
                    showDialog(
                      context: context,
                      builder: (BuildContext context){
                        return LanguagesScreen();
                      }
                    );
                  },
              )
            ],
          )
        ],
      )
    );
  }
}