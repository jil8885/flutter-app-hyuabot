import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_hyuabot_v2/Config/Localization.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void copyDatabase() async {
  final String srcPath = join("assets/databases", "information.db");
  final String destPath = join(await getDatabasesPath(), "information.db");

  ByteData srcData = await rootBundle.load(srcPath);
  await Directory(dirname(destPath)).create(recursive: true);
  ByteData destData;
  try{
    destData = await rootBundle.load(destPath);
    if(srcData.lengthInBytes != destData.lengthInBytes){
      await deleteDatabase(destPath);
      List<int> bytes = srcData.buffer.asUint8List(srcData.offsetInBytes, srcData.lengthInBytes);
      await new File(destPath).writeAsBytes(bytes, flush: true);
    }
  } catch(_){
    await deleteDatabase(destPath);
    List<int> bytes = srcData.buffer.asUint8List(srcData.offsetInBytes, srcData.lengthInBytes);
    await new File(destPath).writeAsBytes(bytes, flush: true);
  }
}


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Widget _logoImage = Image.asset('assets/images/hanyang-phone.png');

  startTime() async {
    copyDatabase();
    var _duration = new Duration(milliseconds: 500);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Get.offAllNamed('/HomeScreen');
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body:  Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          _logoImage,
        ],
      ),
    );
  }
}