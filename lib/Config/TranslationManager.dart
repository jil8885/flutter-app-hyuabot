import 'dart:convert';

import 'package:get/get.dart';
import 'package:flutter_app_hyuabot_v2/Config/Language.dart';

class TranslationManager extends Translations  {
  @override
  Map<String, Map<String, String>> get keys => {
    'ko_KR' : ko_KR,
    'en_US' : en_US,
    'zh' : zh
  };
}