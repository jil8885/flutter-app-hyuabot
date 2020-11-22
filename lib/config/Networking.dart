import 'package:flutter/foundation.dart';

String getAPIServer(){
  String apiServer;
  if(kReleaseMode){
    apiServer = "https://personal-sideprojects-beta.du.r.appspot.com";
  } else{
    apiServer = "http://192.168.123.109:8080";
  }
  return apiServer;
}