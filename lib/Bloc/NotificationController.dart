import 'package:get/get.dart';

class NotificationController extends GetxController{
  String content = "";
  addNotification(String data){
    content = data;
    update();
  }
}