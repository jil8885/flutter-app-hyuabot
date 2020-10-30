import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

import 'package:chatbot/config/style.dart';
import 'package:theme_provider/theme_provider.dart';

class SettingScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(),
      body: Container(
        padding: const EdgeInsets.all(12.0),
        color: Theme.of(context).backgroundColor,
        child: SettingsList(
          backgroundColor: Theme.of(context).backgroundColor,
          sections: [
            SettingsSection(
              title: "settings",
              tiles: [
                SettingsTile(title: "Dark Mode", leading: Icon(Icons.wb_sunny), onTap: ()=>{showDialog(context: context, builder: (_) => ThemeConsumer(child: ThemeDialog(),))},)
              ],
            )
          ],
        ),
      )
    );
  }

}