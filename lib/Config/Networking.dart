import 'package:flutter/foundation.dart';

String getAPIServer(){
  String apiServer;
  if(kReleaseMode){
    apiServer = "https://personal-sideprojects-beta.du.r.appspot.com";
  } else{
    apiServer = "http://192.168.0.112:8000";
  }
  return apiServer;
}