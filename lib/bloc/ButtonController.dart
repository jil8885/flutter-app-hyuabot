import 'package:rxdart/rxdart.dart';

class MainButtonPressed{
  final _mainButtonSubject = BehaviorSubject<Map<String, dynamic>>();
  MainButtonPressed(){
    updateMainButtonIndex({"index": 999, "expanded": false});
  }

  void backToMain(){
    _mainButtonSubject.add({"index": 999, "expanded": false});
  }

  void updateMainButtonIndex(Map<String, dynamic> data) {
    _mainButtonSubject.add(data);
  }

  void updateMainButtonExpand({bool expand=false}) {
    _mainButtonSubject.add({"index": 999, "expanded": expand});
  }

  Stream<Map<String, dynamic>> get mainButtonIndex => _mainButtonSubject.stream;
}


class SubButtonPressed{
  final _subButtonSubject = BehaviorSubject<int>();
  SubButtonPressed(){
    updateSubButtonIndex(-1);
  }

  void resetSubButtonIndex(){
    _subButtonSubject.add(-1);
  }

  void updateSubButtonIndex(int index) {
    _subButtonSubject.add(index);
  }

  Stream<int> get subButtonIndex => _subButtonSubject.stream;
}