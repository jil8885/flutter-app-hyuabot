import 'package:rxdart/rxdart.dart';

class MainButtonPressed{
  final _mainButtonSubject = BehaviorSubject<int>();
  MainButtonPressed(){
    updateMainButtonIndex(999);
  }

  void backToMain(){
    _mainButtonSubject.add(999);
  }

  void updateMainButtonIndex(int index) {
    _mainButtonSubject.add(index);
  }

  Stream<int> get mainButtonIndex => _mainButtonSubject.stream;
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