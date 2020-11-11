import 'package:flutter/foundation.dart';

String getAPIServer(){
  String apiServer;
  if(kReleaseMode){
    apiServer = "https://personal-sideprojects-beta.du.r.appspot.com";
  } else{
    apiServer = "http://roadtechftp.iptime.org:8000";
  }
  return apiServer;
}