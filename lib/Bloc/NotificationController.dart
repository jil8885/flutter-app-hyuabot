import 'package:rxdart/rxdart.dart';

class NotificationController{
  final BehaviorSubject<String> _subject = BehaviorSubject<String>();
  addNotification(String data){
    _subject.add(data);
  }

  dispose(){
    _subject.close();
  }

  Stream<String> get timetableInfo => _subject.stream;
}