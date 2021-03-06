import 'package:flutter/foundation.dart';

String getAPIServer(){
  String apiServer;
  if(kReleaseMode){
    apiServer = "personal-sideprojects-beta.du.r.appspot.com";
  } else{
    apiServer = "192.168.219.103:8080";
  }
  return apiServer;
}